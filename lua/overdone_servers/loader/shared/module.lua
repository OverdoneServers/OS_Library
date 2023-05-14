if OverdoneServers.IncludeData == nil then return end
local ModuleData = OverdoneServers.IncludeData

local MODULE = {}

function MODULE:IsEnabled()
    return self._Enabled
end

function MODULE:SetEnabled(enabled)
    if self._Enabled then
        if enabled then
            return false
        else
            self:OnDisable()
        end
    elseif not self._Enabled then
        if not enabled then
            return false
        else
            self:OnEnable()
        end
    end
    self._Enabled = enabled
    return true
end

function MODULE:Enable() 
    return self:SetEnabled(true)
end

function MODULE:Disable() 
    return self:SetEnabled(false)
end

function MODULE:Awake() end

function MODULE:Start() end

function MODULE:OnEnable() end

function MODULE:OnDisable() end

function MODULE:OnDestory() end

function MODULE:OnRemove()
    self:OnDestory()
end

if SERVER then
    function MODULE:AddPermission(permission, defaultRank, displayName)
        OverdoneServers:AddPermission(ModuleData.FolderName .. "_" .. permission, defaultRank, displayName)
    end
end

function MODULE:HasPermission(ply, permission)
    return OverdoneServers:HasPermission(ply, ModuleData.FolderName .. "_" .. permission)
end

MODULE.DebugEntries = {}

OverdoneServers:AddMetaTable(ModuleData, MODULE)

function ModuleData:Font(fontName)
    return self.FontLocation .. fontName
end

function ModuleData:AddDebugEntry(name, description, funcDo, funcGet)
    self.DebugEntries[name] =
        {Description = description, FuncDo = funcDo, FuncGet = funcGet}
end

OverdoneServers.IncludeData = nil

return ModuleData