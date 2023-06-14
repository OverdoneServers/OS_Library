local StatefulHooks = {}
local hookPrefix = OverdoneServers.LibraryModuleName .. ":StatefulHooks:"

-- Add a hook to the list of hooks under the specified hookType to be called at the specified state(s)
function StatefulHooks:Add(hookType, name, func, states)
    if (not self.GlobalData.AllHooks[hookType] or isstring(self.GlobalData.AllHooks[hookType])) then
        Error("Hook type \"" .. hookType .. "\" does not exist!")
    end

    if (not isfunction(func)) then
        Error("Function \"" .. func .. "\" is not a function!")
    end

    if (states == nil) then
        states = {"Default"}
    elseif (not istable(states)) then
        states = {states}
    end

    for _, s in ipairs(states) do
        if (self.GlobalData.States[s] == nil) then
            Error("State \"" .. s .. "\" does not exist!")
        end
    end
    self.GlobalData.AllHooks[hookType].Hooks[name] = {states = states, func = func}
end

function StatefulHooks:Remove(hookType, name)
    self.GlobalData.AllHooks[hookType].Hooks[name] = nil
end

function StatefulHooks:EnableState(state)
    self.GlobalData.States[state] = true
end

function StatefulHooks:DisableState(state)
    self.GlobalData.States[state] = false
end

function StatefulHooks:AddState(state)
    if (self.GlobalData.States[state]) then return end
    self.GlobalData.States[state] = false
end

function StatefulHooks:RemoveState(state)
    self.GlobalData.States[state] = nil
end

function StatefulHooks:GetResult(hookType)
    return self.GlobalData.AllHooks[hookType].Result
end

-- Is at least one of the specified states enabled?
function StatefulHooks:HookCanRun(state)
    if (isstring(state)) then return self.GlobalData.States[state] == true end

    for _, s in ipairs(state) do
        if (self.GlobalData.States[s] == true) then
            return true
        end
    end

    return false
end

function StatefulHooks:GetEnabledStates()
    local states = {}

    for state, enabled in pairs(self.GlobalData.States) do
        if (enabled == true) then
            table.insert(states, state)
        end
    end

    return states
end

function StatefulHooks:_initialize()
    self.GlobalData.AllHooks = {}
    self.GlobalData.States = {Default = true}

    -- What events are we listening to?
    local AddHookType = function(hookType)
        self.GlobalData.AllHooks[hookType] = self.GlobalData.AllHooks[hookType] or {}
        self.GlobalData.AllHooks[hookType].Hooks = self.GlobalData.AllHooks[hookType].Hooks or {}
    end

    local defaultHookTypes = {
        CLIENT = {
            function()
                local hookType = "CalcView"
                AddHookType(hookType)
    
                local viewKeys = {"origin", "angles", "fov"}
    
                hook.Add(hookType, hookPrefix .. hookType, function(ply, pos, angles, fov)
                    if (table.IsEmpty(self.GlobalData.AllHooks[hookType].Hooks)) then return end
                    local shouldReturn = false
    
                    -- The following checks are to make sure we don't run the hook if we don't need to
                    if GetViewEntity() ~= ply then return end
                    if not ply:Alive() then return end
                    if ply:InVehicle() then return end
    
                    local view = {origin = pos, angles = angles, fov = fov}
                    local previousView = table.Copy(view)
    
                    for name, cv in pairs(self.GlobalData.AllHooks[hookType].Hooks) do
                        local shouldRun = StatefulHooks:HookCanRun(cv.states)
                        if shouldRun then
                            local newView = cv.func(ply, view.origin, view.angles, view.fov)
    
                            for _, key in ipairs(viewKeys) do
                                if newView and newView[key] then
                                    view[key] = view[key] - previousView[key] + newView[key]
                                    previousView[key] = newView[key]
                                    shouldReturn = true
                                end
                            end
                        end
                    end
                    
                    self.GlobalData.AllHooks[hookType].Result = view
                    if (not shouldReturn) then return end
                    return view
                end)
            end,
            function()
                local hookType = "CalcViewModelView"
                AddHookType(hookType)
    
                hook.Add(hookType, hookPrefix .. hookType, function(wep, vm, oldPos, oldAng, pos, ang)
                    if (table.IsEmpty(self.GlobalData.AllHooks[hookType].Hooks)) then return end
                    local shouldReturn = false
    
                    local currentOrigin, currentAngles = pos, ang
                    local previousOrigin, previousAngles = currentOrigin, currentAngles
    
                    for name, cv in pairs(self.GlobalData.AllHooks[hookType].Hooks) do
                        local shouldRun = StatefulHooks:HookCanRun(cv.states)
                        if shouldRun then
                            local newOrigin, newAngles = cv.func(wep, vm, oldPos, oldAng, currentOrigin, currentAngles)
                            
                            if (newOrigin) then
                                currentOrigin = currentOrigin - previousOrigin + newOrigin
                                previousOrigin = newOrigin
                                shouldReturn = true
                            end
    
                            if (newAngles) then
                                currentAngles = currentAngles - previousAngles + newAngles
                                previousAngles = newAngles
                                shouldReturn = true
                            end
                        end
                    end
    
                    self.GlobalData.AllHooks[hookType].Result = {origin = currentOrigin, angles = currentAngles}
                    if (not shouldReturn) then return end
                    return currentOrigin, currentAngles
                end)
            end,
        },
        SERVER = {
    
        },
        SHARED = {
    
        }
    }
    
    -- Add default hook types
    for _, hooks in pairs(defaultHookTypes) do
        for _, hookFunc in ipairs(hooks) do
            hookFunc()
        end
    end

    defaultHookTypes = nil -- We don't need this anymore
end

return StatefulHooks