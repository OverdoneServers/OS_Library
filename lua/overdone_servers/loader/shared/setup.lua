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
    //Module can be accessed here by using OverdoneServers.IncludeData
    if module != lastModule then //TODO: make the name change the spacing of -----
        self:PrettyPrint("///////////////////////////////////////////////////")
        self:PrettyPrint("//------------------ Loading " .. (self:ValidModuleName(module) and module or "Invalid Name") .. " ---------------------//")
        self:PrettyPrint("///////////////////////////////////////////////////")
        lastModule = module
    end

	if type == 1 and lastType != 1 then self:PrettyPrint("//------------------ SERVER ---------------------//") lastType = 1 end
	if type == 2 and lastType != 2 then self:PrettyPrint("//------------------ CLIENT ---------------------//") lastType = 2 end
	if type == 3 and lastType != 3 then self:PrettyPrint("//------------------ SHARED ---------------------//") lastType = 3 end

    local fil = self.MainDir .. "/modules/" .. module .. "/" .. (type == 1 and "server" or type == 2 and "client" or type == 3 and "shared") .. "/" .. f

    local okay = true
    if not file.Exists(fil, "LUA") then //TODO: Just have this replace the "Initialize" text
        f = f .. " - NOT FOUND"
        okay = false
    elseif not (file.Size(fil, "LUA") > 0) then
        f = f .. " - EMPTY"
        okay = false
    end

	self:PrettyPrint("// [ Initialize ]: " .. f .. string.rep(" ", 30 - f:len()) .. "//")

    if okay then
        if type == 1 and SERVER then include(fil) end
        if type == 2 then AddCSLuaFile(fil) if CLIENT then include(fil) end end
        if type == 3 then AddCSLuaFile(fil) include(fil) end
    else
        return false
    end
end

function OverdoneServers:AddModule(moduleData)
    --moduleData.FolderName = 

    //TODO: Check if module already exists

    self.IncludeData = moduleData
    self.Modules[moduleData.FolderName] = include(self.LoaderDir .. "/shared/module.lua")
    
end

--[[
    Insted of removing values, this function will ADD data.
    Usage: Main table, metatable, should we overwrite data that exists
]]--

function OverdoneServers:AddMetaTable(tab, metatable, overwrite)
    for k,v in pairs(metatable) do
        if tab[k] == nil or overwrite then
            tab[k] = v
        end 
    end
end

function OverdoneServers:LoadModule(module)
    local failed = false

    local ModuleName, FilesToLoad = module.FolderName, module.FilesToLoad

    for type, files in pairs(FilesToLoad) do
        for _, f in ipairs(files) do
                if type == "Server" and SERVER then
                if OverdoneServers:LoadLuaFile(ModuleName, f, 1) == false then failed = true end
            elseif type == "Client" then
                if OverdoneServers:LoadLuaFile(ModuleName, f, 2) == false then failed = true end
            elseif type == "Shared" then
                if OverdoneServers:LoadLuaFile(ModuleName, f, 3) == false then failed = true end
            end
        end
    end
    
    return not failed
end