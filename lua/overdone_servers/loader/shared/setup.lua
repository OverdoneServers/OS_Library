AddCSLuaFile()
function OverdoneServers:PrettyPrint(txt)
    if SERVER then
        MsgC(Color(251, 59, 91), txt .. "\n")
    else
        MsgC(Color(193, 193, 98), txt .. "\n")
    end
end

OverdoneServers.ConsoleColors = {
    BLACK = Color(0,0,0),
    DARK_BLUE = Color(0,0,151),
    DARK_GREEN = Color(0,151,0),
    LIGHT_BLUE = Color(0,151,151),
    DARK_RED = Color(151,0,0),
    PURPLE = Color(151,0,151),
    DARK_YELLOW = Color(151,151,0),
    GRAY = Color(151,151,151),
    LIGHT_GRAY = Color(240,240,240),
    BLUE = Color(0,0,240),
    GREEN = Color(0,240,0),
    CYAN = Color(0,240,240),
    RED = Color(240,0,0),
    MAGENTA = Color(240,0,240),
    YELLOW = Color(240,240,0),
    WHITE = Color(255,255,255)
}

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
    else
        type = 0
    end

    local displayName = istable(module) and module.DisplayName or isstring(module) and module or "Invalid Name"

    if module != self.Loading.lastModule then -- TODO: make the name change the spacing of -----
        self:PrettyPrint("///////////////////////////////////////////////////")
        self:PrettyPrint(
            "//------------------ " ..
            ((istable(module) and module.FinishedLoading or nil) and "Reloading" or "Loading") ..
            " " ..
            (self:ValidModuleName(displayName) and displayName or "Invalid Name") ..
            " ---------------------//"
        )
        self:PrettyPrint("///////////////////////////////////////////////////")
        if (istable(module)) then module.FinishedLoading = true end
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
    -- Module can be accessed here by using OverdoneServers.IncludeData

    local fil = self.MainDir .. "/modules/" .. module .. "/" .. (type == 1 and "server" or type == 2 and "client" or type == 3 and "shared") .. "/" .. f

    local okay = true
    if not CLIENT then
        if not file.Exists(fil, "LUA") then -- TODO: Just have this replace the "Initialize" text
            f = f .. " - NOT FOUND"
            okay = false
        elseif file.Size(fil, "LUA") <= 0 then
            f = f .. " - EMPTY"
            okay = false
        end
    end
    self:PrettyPrint("// [ Initialize ]: " .. f .. string.rep(" ", 30 - f:len()) .. "//")

    if okay then
        if type == 1 and SERVER then include(fil) end
        if type == 2 then if SERVER then AddCSLuaFile(fil) end if CLIENT then include(fil) end end
        if type == 3 then if SERVER then AddCSLuaFile(fil) end include(fil) end
    else
        return false
    end
end

function OverdoneServers:AddModule(moduleData)
    self.IncludeData = moduleData
    self.Modules2Load[moduleData.FolderName] = include(self.LoaderDir .. "/shared/module.lua")
end

/*
    Insted of removing values, this function will ADD data.
    Usage: Main table, metatable, should we overwrite data that exists
*/

function OverdoneServers:AddMetaTable(tab, metatable, overwrite)
    for k,v in pairs(metatable) do
        if tab[k] == nil or overwrite then
            tab[k] = v
        end
    end
end

function OverdoneServers:LoadModule(module)

    local failed = nil

    -- TODO: default names, hooks, and networking, should be moved to another file. Possibly module.lua

    local defaultName = "OS:" .. module.FolderName .. ":"
    if (not module.FontLocation) then module.FontLocation = defaultName end
    if (not module.NetworkPrefix) then module.NetworkPrefix = defaultName end
    if (not module.HookPrefix) then module.HookPrefix = defaultName end

    function module:HookAdd(...) 
        local args = {...}
        args[2] = self.HookPrefix .. args[2]
        hook.Add(unpack(args))
    end

    function module:HookRemove(eventName, identifier)
        hook.Remove(eventName, self.HookPrefix .. identifier)
    end

    function module:AddNetworkString(messageName)
        util.AddNetworkString(self.NetworkPrefix .. messageName)
    end

    function module:NetStart(messageName, ...)
        net.Start(self.NetworkPrefix .. messageName, ...)
    end
    
    function module:NetReceive(messageName, callback)
        net.Receive(self.NetworkPrefix .. messageName, callback)
    end

    if not istable(module.DataToLoad) then self:PrintLoadingText(module) return 2 end

    for type, files in pairs(istable(module.DataToLoad) and module.DataToLoad or {}) do
        for _, f in ipairs(files) do
            if (not CLIENT or type != "Server") and type != "Materials" then
                self:PrintLoadingText(module, type)
            end

            if type == "Server" and SERVER then
                if self:LoadLuaFile(module.FolderName, f, 1) == false then failed = 1 end
            elseif type == "Client" then
                if self:LoadLuaFile(module.FolderName, f, 2) == false then failed = 1 end
            elseif type == "Shared" then
                if self:LoadLuaFile(module.FolderName, f, 3) == false then failed = 1 end
            elseif type == "Fonts" then
                self:LoadFont(f, module.FontLocation)
            elseif type == "Materials" then
                if isstring(f) then
                    -- TODO: Make this add all files in the specified directory
                elseif istable(f) then
                    -- TODO: Make this add the specific file with resource.AddFile()
                end
            end
        end
    end

    return failed

end

function OverdoneServers:LoadFont(f, fontLocation)
    if f[1] == nil or f[2] == nil or f[3] == nil then
        f[1] = f[1] .. " - ERROR"
        self:PrettyPrint("// [ Adding Font ]: " .. f[1] .. string.rep(" ", 29 - f[1]:len()) .. "//")
        return
    end
    self:PrettyPrint("// [ Adding Font ]: " .. f[1] .. string.rep(" ", 29 - f[1]:len()) .. "//")
    if SERVER then resource.AddSingleFile("resource/fonts/" .. f[2]) end
    if CLIENT then
        if f[3].noScale != true and f[3].size != nil then
            f[3].size = ScreenScale(f[3].size)
        end
        surface.CreateFont(fontLocation .. f[1], f[3])
    end
end

function OverdoneServers:LoadSharedFile(file)
    if SERVER then AddCSLuaFile(file) end
    include(file)
end

function OverdoneServers:LoadClientFile(file)
    if SERVER then AddCSLuaFile(file) end
    if CLIENT then include(file) end
end

function OverdoneServers:GetLibrary(name)
    name = string.lower(name)
    if name == "enum" or name == "enums" then
        return include(OverdoneServers.LibrariesDir .. "/lua-enum.lua")
    elseif name == "lua-semver" or name == "versions" or name == "version" or name == "versioning" then
        return include(OverdoneServers.LibrariesDir .. "/lua-semver.lua")
    else
        error("Invalid Library used: \"" .. name .. "\"")
        return nil
    end
end

function OverdoneServers:WaitForTicks(ticks2wait, func)
    for i = 1,ticks2wait do
        local f = func
        func = function() timer.Simple(0, f) end
    end
    func()
end

if SERVER then
    hook.Add("PlayerInitialSpawn", "OverdoneServers:InitSpawn", function(ply)
        hook.Add("SetupMove", "OverdoneServers:SetupMove:" .. ply:SteamID64(), function(plyy)
            if ply == plyy then
                hook.Remove("SetupMove", "OverdoneServers:SetupMove:" .. ply:SteamID64())
                hook.Run("OverdoneServers:PlayerReady", ply)
            end
        end)
    end)
elseif CLIENT then
    hook.Add("SetupMove", "OverdoneServers:SetupMove", function(ply)
        if LocalPlayer() == ply then
            hook.Remove("SetupMove", "OverdoneServers:SetupMove")
            hook.Run("OverdoneServers:PlayerReady", ply)
        end
    end)
end

for _,p in ipairs(player.GetHumans()) do
    hook.Run("OverdoneServers:PlayerReady", p)
end

local lua_semver = OverdoneServers:GetLibrary("versioning")
function OverdoneServers:CompareVersions(v1, v2) -- Returns is V1 Greater or Equal to V2 and the reason that it returned what value
    assert(isstring(v1) and isstring(v2), "Both Versions Must Be Strings!")
    return lua_semver(v1) >= lua_semver(v2)
end