local ModuleData = OverdoneServers.IncludeData
print("----------------------------------------------")
PrintTable(ModuleData)
print("----------------------------------------------")

local MODULE = {}

MODULE._Enabled = nil

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

function MODULE:Awake()
end

function MODULE:Start()
end

function MODULE:OnEnable()
end

function MODULE:OnDisable()
end

function MODULE:OnDestory()
end

function MODULE:OnRemove()
    self:OnDestory()
end

setmetatable(MODULE, ModuleData)

return MODULE