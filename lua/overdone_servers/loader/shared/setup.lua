AddCSLuaFile()

function OverdoneServers:PrettyPrint(txt)
    if SERVER then
        MsgC(Color(251, 59, 91), txt .. "\n")
    else
        MsgC(Color(193, 193, 98), txt .. "\n")
    end
end

OverdoneServers.Loading = {}

OverdoneServers.Loading.Space = " "
if (system.IsWindows() or system.IsLinux()) then
    OverdoneServers.Loading.Align = TEXT_ALIGN_CENTER
    OverdoneServers.Loading.ModuleVerticalLine = "║"
    OverdoneServers.Loading.ModuleHeader = "╔" .. string.rep("═", OverdoneServers.ConsoleWidth-2) .. "╗"
    OverdoneServers.Loading.ModuleFooter = "╚" .. string.rep("═", OverdoneServers.ConsoleWidth-2) .. "╝"
    OverdoneServers.Loading.ModuleHeaderSeparator = "╠" .. string.rep("═", OverdoneServers.ConsoleWidth-2) .. "╣"
    OverdoneServers.Loading.ModuleDataSeparator = "╟" .. string.rep("─", OverdoneServers.ConsoleWidth-2) .. "╢"
else
    OverdoneServers.Loading.Align = TEXT_ALIGN_LEFT
    OverdoneServers.Loading.ModuleVerticalLine = "|"
    OverdoneServers.Loading.ModuleHeader = "|" .. string.rep("=", OverdoneServers.ConsoleWidth/2)
    OverdoneServers.Loading.ModuleFooter = "|" .. string.rep("_", OverdoneServers.ConsoleWidth/2)
    OverdoneServers.Loading.ModuleHeaderSeparator = "|" .. string.rep("=", OverdoneServers.ConsoleWidth/2)
    OverdoneServers.Loading.ModuleDataSeparator = "|" .. string.rep("- ", OverdoneServers.ConsoleWidth/3)
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

function OverdoneServers:GetModule(folderName)
    return OverdoneServers.Modules[folderName]
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

function OverdoneServers:LoadSharedFile(file)
    AddCSLuaFile(file)
    include(file)
end

function OverdoneServers:LoadClientFile(file)
    AddCSLuaFile(file)
    if CLIENT then include(file) end
end

OverdoneServers.ModuleLoadType = {
    UNKNOWN = 0/0,
    CUSTOM = 0,
    SERVER = 1,
    CLIENT = 2,
    SHARED = 3,
    FONTS = 4,

    FromString = function(str)
        return OverdoneServers.ModuleLoadType[string.upper(str)] or OverdoneServers.ModuleLoadType.CUSTOM
    end,
    ToString = function(type)
        return OverdoneServers.TableHelper:FindKeyByValue(OverdoneServers.ModuleLoadType, type) or "CUSTOM"
    end
}

OverdoneServers.Loading.lastModule = "" -- Used for internal use only
OverdoneServers.Loading.lastType = OverdoneServers.ModuleLoadType.UNKNOWN -- Used for internal use only

function OverdoneServers:PrintLoadingText(module, type)
    local displayName = istable(module) and module.DisplayName or isstring(module) and module or "Invalid Name"

    if module != self.Loading.lastModule then
        self:PrettyPrint(OverdoneServers.Loading.ModuleHeader)
        self:PrettyPrint(
            OverdoneServers.Loading.ModuleVerticalLine ..
            self.BetterText:AlignString(((istable(module) and module.FinishedLoading or nil) and "Reloading" or "Loading") ..
            " " ..
            (displayName or "Invalid Name"), OverdoneServers.ConsoleWidth-2, OverdoneServers.Loading.Align) ..
            (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
        )
        self:PrettyPrint(OverdoneServers.Loading.ModuleHeaderSeparator)
        if (istable(module)) then module.FinishedLoading = true end
        self.Loading.lastModule = module
        self.Loading.lastType = OverdoneServers.ModuleLoadType.UNKNOWN
    end

    if type != self.Loading.lastType then
        self:PrettyPrint(
            OverdoneServers.Loading.ModuleVerticalLine ..
            self.BetterText:AlignString(OverdoneServers.ModuleLoadType.ToString(type), OverdoneServers.ConsoleWidth-2, OverdoneServers.Loading.Align) ..
            (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
        )
        self:PrettyPrint(OverdoneServers.Loading.ModuleDataSeparator)
        self.Loading.lastType = type
    end
end

function OverdoneServers:LoadLuaFile(moduleDirectory, fileName, moduleLoadType)
    local fileToLoadPath = OverdoneServers.ModulesDir .. "/" .. moduleDirectory .. "/"

        if moduleLoadType == OverdoneServers.ModuleLoadType.SERVER then -- TODO: use to string function in table
            fileToLoadPath = fileToLoadPath .. "server"
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.CLIENT then
            fileToLoadPath = fileToLoadPath .. "client"
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.SHARED then
            fileToLoadPath = fileToLoadPath .. "shared"
        end

        fileToLoadPath = fileToLoadPath .. "/" .. fileName

    local okay = true
    if not CLIENT then
        if not file.Exists(fileToLoadPath, "LUA") then
            fileName = fileName .. " - NOT FOUND"
            okay = false
        elseif file.Size(fileToLoadPath, "LUA") <= 0 then
            fileName = fileName .. " - EMPTY"
            okay = false
        end
    end

    OverdoneServers:PrettyPrint(
        OverdoneServers.Loading.ModuleVerticalLine ..
        OverdoneServers.BetterText:AlignString("[ Initialize ]: " .. fileName, OverdoneServers.ConsoleWidth-2, TEXT_ALIGN_LEFT, OverdoneServers.Loading.Space) ..
        (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
    )
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
    local err = false
    if f[1] == nil or f[2] == nil or f[3] == nil then
        f[1] = f[1] .. " - ERROR"
        err = true
        return
    end

    OverdoneServers:PrettyPrint(
        OverdoneServers.Loading.ModuleVerticalLine ..
        OverdoneServers.BetterText:AlignString("[ Adding Font ]: " .. f[1], OverdoneServers.ConsoleWidth-2, TEXT_ALIGN_LEFT) ..
        (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
)
    if err then return end
    if SERVER then resource.AddSingleFile("resource/fonts/" .. f[2]) end
    if CLIENT then
        if f[3].noScale != true and f[3].size != nil then
            f[3].size = ScreenScale(f[3].size)
        end
        surface.CreateFont(fontLocation .. f[1], f[3])
    end
end