AddCSLuaFile()

OverdoneServers.Loading = {}
OverdoneServers.Loading.lastModule = ""
OverdoneServers.Loading.lastType = -0

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

function OverdoneServers:LoadSharedFile(file)
    AddCSLuaFile(file)
    include(file)
end

function OverdoneServers:LoadClientFile(file)
    AddCSLuaFile(file)
    if CLIENT then include(file) end
end

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
            (displayName or "Invalid Name") ..
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


OverdoneServers.ModuleLoadType = {
    SERVER = 1,
    CLIENT = 2,
    SHARED = 3,
    FONTS = 4,
    CUSTOM = 0
}

function OverdoneServers:LoadLuaFile(moduleDirectory, fileName, moduleLoadType)
    local fileToLoadPath = OverdoneServers.ModulesLocation .. "/" .. moduleDirectory .. "/"

        if moduleLoadType == OverdoneServers.ModuleLoadType.SERVER then
            fileToLoadPath = fileToLoadPath .. "server"
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.CLIENT then
            fileToLoadPath = fileToLoadPath .. "client"
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.SHARED then
            fileToLoadPath = fileToLoadPath .. "shared"
        end

        fileToLoadPath = fileToLoadPath .. "/" .. fileName

    local okay = true
    if not CLIENT then
        if not file.Exists(fileToLoadPath, "LUA") then -- TODO: Just have this replace the "Initialize" text
            fileName = fileName .. " - NOT FOUND"
            okay = false
        elseif file.Size(fileToLoadPath, "LUA") <= 0 then
            fileName = fileName .. " - EMPTY"
            okay = false
        end
    end
    OverdoneServers:PrettyPrint("// [ Initialize ]: " .. fileName .. string.rep(" ", 30 - fileName:len()) .. "//")

    if okay then
        if moduleLoadType == OverdoneServers.ModuleLoadType.SERVER and SERVER then
            include(fileToLoadPath)
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.CLIENT then
            OverdoneServers:LoadClientFile(fileToLoadPath)
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.SHARED then
            OverdoneServers:LoadSharedFile(fileToLoadPath)
        end
        return true
    else
        return false
    end
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