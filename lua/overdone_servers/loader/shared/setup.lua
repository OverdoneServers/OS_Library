AddCSLuaFile()
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

OverdoneServers.Loading = {}
OverdoneServers.Loading.lastModule = ""
OverdoneServers.Loading.lastType = -0
/*
    1 = SERVER
    2 = CLIENT
    3 = SHARED
    4 = FONT
*/

function OverdoneServers:PrintLoadingText(module, type)
    if isstring(type) then
        type = string.upper(type)
        if type == "SERVER" then type = 1
        elseif type == "CLIENT" then type = 2
        elseif type == "SHARED" then type = 3
        elseif type == "FONTS" then type = 4
        else type = 0 end
    end 

    if module != self.Loading.lastModule then //TODO: make the name change the spacing of -----
        self:PrettyPrint("///////////////////////////////////////////////////")
        self:PrettyPrint("//------------------ Loading " .. (self:ValidModuleName(module) and module or "Invalid Name") .. " ---------------------//")
        self:PrettyPrint("///////////////////////////////////////////////////")
        self.Loading.lastModule = module
        self.Loading.lastType = -0
    end
    
    local sep = function() self:PrettyPrint("//                                               //") end

    if type == 1 and self.Loading.lastType != 1 then sep() self:PrettyPrint("//------------------ SERVER ---------------------//") sep() self.Loading.lastType = 1 end
	if type == 2 and self.Loading.lastType != 2 then sep() self:PrettyPrint("//------------------ CLIENT ---------------------//") sep() self.Loading.lastType = 2 end
	if type == 3 and self.Loading.lastType != 3 then sep() self:PrettyPrint("//------------------ SHARED ---------------------//") sep() self.Loading.lastType = 3 end
	if type == 4 and self.Loading.lastType != 4 then sep() self:PrettyPrint("//------------------ FONTS ----------------------//") sep() self.Loading.lastType = 4 end
	if type == 0 and self.Loading.lastType != 0 then sep() self:PrettyPrint("//------------------ CUSTOM ---------------------//") sep() self.Loading.lastType = 0 end
end

function OverdoneServers:LoadLuaFile(module, f, type)
    //Module can be accessed here by using OverdoneServers.IncludeData

    local fil = self.MainDir .. "/modules/" .. module .. "/" .. (type == 1 and "server" or type == 2 and "client" or type == 3 and "shared") .. "/" .. f

    local okay = true
    if not CLIENT then
        if not file.Exists(fil, "LUA") then //TODO: Just have this replace the "Initialize" text
            f = f .. " - NOT FOUND"
            okay = false
        elseif not (file.Size(fil, "LUA") > 0) then
            f = f .. " - EMPTY"
            okay = false
        end
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

function OverdoneServers:LoadModule(module)//TODO: Change FilesToLoad to DataToLoad or something like it
    local failed = false

    local ModuleName, FilesToLoad = module.FolderName, module.FilesToLoad

    for type, files in pairs(FilesToLoad) do
        for _, f in ipairs(files) do
            if (not CLIENT or type != "Server") and type != "Materials" then 
            self:PrintLoadingText(ModuleName, type)
            end
                if type == "Server" and SERVER then
                if self:LoadLuaFile(ModuleName, f, 1) == false then failed = true end
            elseif type == "Client" then
                if self:LoadLuaFile(ModuleName, f, 2) == false then failed = true end
            elseif type == "Shared" then
                if self:LoadLuaFile(ModuleName, f, 3) == false then failed = true end
            elseif type == "Fonts" then
                module.FontLocation = "OS:" .. ModuleName .. ":"
                if f[1] == nil or f[2] == nil or f[3] == nil then
                    f[1] = f[1] .. " - ERROR"
                    self:PrettyPrint("// [ Adding Font ]: " .. f[1] .. string.rep(" ", 29 - f[1]:len()) .. "//")
                    continue
                end
                self:PrettyPrint("// [ Adding Font ]: " .. f[1] .. string.rep(" ", 29 - f[1]:len()) .. "//")
                if SERVER then resource.AddSingleFile("resource/fonts/" .. f[2]) end
                if CLIENT then
                    if f[3].size != nil then
                        f[3].size = ScreenScale(f[3].size)
                    end
                    surface.CreateFont(module.FontLocation .. f[1], f[3])
                end
            elseif type == "Materials" then
                if isstring(f) then
                    //TODO: Make this add all files in the specified directory
                elseif istable(f) then
                    //TODO: Make this add the specific file with resource.AddFile()
                end 
            end
        end
    end
    
    return not failed
end

function OverdoneServers:LoadSharedFile(file)
    if SERVER then AddCSLuaFile(file) end
    include(file)
end

function OverdoneServers:LoadClientFile(file)
    if SERVER then AddCSLuaFile(file) end
    if CLIENT then include(file) end
end

function OverdoneServers:GetSequentialColor(color)
    local h,s,l = ColorToHSL(color)
    h = h + 1
    if h > 360 then
        h = 0
    end
    local t = HSLToColor(h,s,l)
    return Color(t.r, t.g, t.b, color.a)
end

function OverdoneServers:LightenColor(color)
    return Color(color.r + ((255-color.r)/2), color.g + ((255-color.g)/2), color.b + ((255-color.b)/2))
end

function OverdoneServers:DarkenColor(color)
    return Color(color.r/2, color.g/2, color.b/2)
end

function OverdoneServers:ColorToVector(color)
    return Vector(color.r, color.g, color.b)
end

function OverdoneServers:VectorToColor(vector)
    return Color(vector.x, vector.y, vector.z)
end

