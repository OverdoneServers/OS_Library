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
    if (istable(OverdoneServers.Modules[folderName])) then
        return OverdoneServers.Modules[folderName]
    else
        ErrorNoHalt("OverdoneServers: Attempted to get module '" .. folderName .. "' but it does not exist!\n")
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

function OverdoneServers:LoadFont(f, fontLocation)
    local err = false
    if f[1] == nil or f[2] == nil or f[3] == nil then
        f[1] = f[1] .. " - ERROR"
        err = true
        return
    end

    -- The only time this will be skipped is if we are currently loading sub-libaries
    if isfunction(self.FontLoadedMessage) then self:FontLoadedMessage(f[1]) end

    if err then return end
    if SERVER then resource.AddSingleFile("resource/fonts/" .. f[2]) end
    if CLIENT then
        if f[3].noScale != true and f[3].size != nil then
            f[3].size = ScreenScale(f[3].size)
        end
        surface.CreateFont(fontLocation .. f[1], f[3])
    end
end