function OverdoneServers:PrettyPrint(txt)
	if SERVER then
		MsgC(Color(251, 59, 91), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

function OverdoneServers:ValidModuleName(name)
    return name != "" and name != " " and name != ""
end 

local lastModule = ""
local lastType = 0
function OverdoneServers:LoadLuaFile(module, f, type) //type 1 = SERVER, 2 = CLIENT, 3 = SHARED
    if module != lastModule then //TODO: make the name change the spacing of -----
        self:PrettyPrint("///////////////////////////////////////////////////")
        self:PrettyPrint("//------------------ Loading " .. (self:ValidModuleName(module) and module or "Invalid Name") .. " ---------------------//")
        self:PrettyPrint("///////////////////////////////////////////////////")
        lastModule = module
    end
    
    local file = self.MainDir .. "/modules/" .. module .. "/" .. f

	if type == 1 and lastType != 1 then self:PrettyPrint("//------------------ SERVER ---------------------//") lastType = 1 end
	if type == 2 and lastType != 2 then self:PrettyPrint("//------------------ CLIENT ---------------------//") lastType = 2 end
	if type == 3 and lastType != 3 then self:PrettyPrint("//------------------ SHARED ---------------------//") lastType = 3 end

	self:PrettyPrint("// [ Initialize ]: " .. f .. string.rep(" ", 30 - f:len()) .. "//")

    if type == 1 and SERVER then include(file) end
    if type == 2 then AddCSLuaFile(file) if CLIENT then include(file) end end
    if type == 3 then AddCSLuaFile(file) include(file) end
end

function OverdoneServers:AddModule(moduleData)
    --PrintTable(moduleData)
    //TODO: Check if module already exists
    print("HEYYYYY: ", isstring(moduleData), isstring(moduleData) and moduleData or "")
    self.IncludeData = moduleData
    table.insert(OverdoneServers.Modules, include(self.LoaderDir .. "/shared/module.lua"))

    
end
