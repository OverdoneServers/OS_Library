OverdoneServers.StatefulHooks = OverdoneServers.StatefulHooks or {}

local SHooks = OverdoneServers.StatefulHooks
local hookPrefix = OverdoneServers.LibraryModuleName .. ":StatefulHooks:"

SHooks.AllHooks = SHooks.AllHooks or {}
SHooks.States = SHooks.States or {Default = true}

-- Add a hook to the list of hooks under the specified hookType to be called at the specified state(s)
function SHooks:Add(hookType, name, func, states)
    if (not self.AllHooks[hookType] or isstring(self.AllHooks[hookType])) then
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
        if (self.States[s] == nil) then
            Error("State \"" .. s .. "\" does not exist!")
        end
    end
    self.AllHooks[hookType].Hooks[name] = {states = states, func = func}
end

function SHooks:Remove(hookType, name)
    self.AllHooks[hookType].Hooks[name] = nil
end

function SHooks:EnableState(state)
    self.States[state] = true
end

function SHooks:DisableState(state)
    self.States[state] = false
end

function SHooks:AddState(state)
    if (self.States[state]) then return end
    self.States[state] = false
end

function SHooks:RemoveState(state)
    self.States[state] = nil
end

-- Is at least one of the specified states enabled?
function SHooks:HookCanRun(state)
    if (isstring(state)) then return self.States[state] == true end

    for _, s in ipairs(state) do
        if (self.States[s] == true) then
            return true
        end
    end

    return false
end

function SHooks:GetEnabledStates()
    local states = {}

    for state, enabled in pairs(self.States) do
        if (enabled == true) then
            table.insert(states, state)
        end
    end

    return states
end

-- What events are we listening to?
function SHooks:AddHookType(hookType)
    self.AllHooks[hookType] = self.AllHooks[hookType] or {}
    self.AllHooks[hookType].Hooks = self.AllHooks[hookType].Hooks or {}
end

local defaultHookTypes = {
    CLIENT = {
        function()
            local hookType = "CalcView"
            SHooks:AddHookType(hookType)

            local viewKeys = {"origin", "angles", "fov"}

            hook.Add(hookType, hookPrefix .. hookType, function(ply, pos, angles, fov)
                if (table.IsEmpty(SHooks.AllHooks[hookType].Hooks)) then return end
                local shouldReturn = false

                -- The following checks are to make sure we don't run the hook if we don't need to
                if GetViewEntity() ~= ply then return end
                if not ply:Alive() then return end
                if ply:InVehicle() then return end

                local view = {origin = pos, angles = angles, fov = fov}
                local previousView = table.Copy(view)

                for name, cv in pairs(SHooks.AllHooks[hookType].Hooks) do
                    local shouldRun = SHooks:HookCanRun(cv.states)
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
                
                SHooks.AllHooks[hookType].Result = view
                if (not shouldReturn) then return end
                return view
            end)
        end,
        function()
            local hookType = "CalcViewModelView"
            SHooks:AddHookType(hookType)

            hook.Add(hookType, hookPrefix .. hookType, function(wep, vm, oldPos, oldAng, pos, ang)
                if (table.IsEmpty(SHooks.AllHooks[hookType].Hooks)) then return end
                local shouldReturn = false

                local currentOrigin, currentAngles = pos, ang
                local previousOrigin, previousAngles = currentOrigin, currentAngles

                for name, cv in pairs(SHooks.AllHooks[hookType].Hooks) do
                    local shouldRun = SHooks:HookCanRun(cv.states)
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

                SHooks.AllHooks[hookType].Result = {origin = currentOrigin, angles = currentAngles}
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