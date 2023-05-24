AddCSLuaFile()
local Module = {}

Module.__index = Module

function Module.new(ModuleTable, folderName)
    setmetatable(ModuleTable, Module)
    ModuleTable.FolderName = ModuleTable.FolderName or folderName
    ModuleTable.DisplayName = ModuleTable.DisplayName or ModuleTable.FolderName
    ModuleTable._Enabled = false
    ModuleTable.Data = ModuleTable.Data or {}
    ModuleTable.DebugEntries = ModuleTable.DebugEntries or {}
    ModuleTable.Version = ModuleTable.Version or "0.0.0"
    ModuleTable.Dependencies = ModuleTable.Dependencies or {}
    ModuleTable.SoftDependencies = ModuleTable.SoftDependencies or {}

    local defaultName = "OverdoneServers:" .. ModuleTable.FolderName .. ":"
    ModuleTable.FontLocation = ModuleTable.FontLocation or defaultName
    ModuleTable.NetworkPrefix = ModuleTable.NetworkPrefix or defaultName
    ModuleTable.HookPrefix = ModuleTable.HookPrefix or defaultName

    return ModuleTable
end

function Module:IsEnabled()
    return self._Enabled
end

function Module:SetEnabled(enabled)
    if enabled == self._Enabled then return false end

    self._Enabled = enabled
    if enabled then
        self:OnEnable()
    else
        self:OnDisable()
    end

    return true
end

function Module:Enable()
    return self:SetEnabled(true)
end

function Module:Disable()
    return self:SetEnabled(false)
end

function Module:Awake() end -- called when _modules file is read

function Module:Start() end -- called after all modules have been loaded

function Module:OnEnable() end -- called when module has loaded

function Module:OnDisable() end

if SERVER then
    function Module:AddPermission(permission, defaultRank, displayName)
        OverdoneServers:AddPermission(self.FolderName .. "_" .. permission, defaultRank, displayName)
    end
end

function Module:HasPermission(ply, permission)
    return OverdoneServers:HasPermission(ply, self.FolderName .. "_" .. permission)
end

function Module:Font(fontName)
    return self.FontLocation .. fontName
end

function Module:AddDebugEntry(name, description, funcDo, funcGet, options)
    self.DebugEntries[name] =
        {Description = description, FuncDo = funcDo, FuncGet = funcGet, Options = options}
end

function Module:Print(...)
    print(self.DisplayName .. ": ", ...)
end
function Module:PrintDebug(...)
    print("[DEBUG] " .. self.DisplayName .. ": ", ...)
end

function Module:HookAdd(...) 
    local args = {...}
    args[2] = self.HookPrefix .. args[2]
    hook.Add(unpack(args))
end

function Module:HookRemove(eventName, identifier)
    hook.Remove(eventName, self.HookPrefix .. identifier)
end

function Module:AddNetworkString(messageName)
    util.AddNetworkString(self.NetworkPrefix .. messageName)
end

function Module:GetNetworkString(messageName)
    return self.NetworkPrefix .. messageName
end

function Module:NetStart(messageName, ...)
    net.Start(self.NetworkPrefix .. messageName, ...)
end

function Module:NetReceive(messageName, callback)
    net.Receive(self.NetworkPrefix .. messageName, callback)
end

return Module