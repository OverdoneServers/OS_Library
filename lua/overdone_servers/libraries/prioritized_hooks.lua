OverdoneServers.PrioritizedHooks = OverdoneServers.PrioritizedHooks or {}

local HookPS = OverdoneServers.PrioritizedHooks
local hookPrefix = OverdoneServers.LibraryModuleName .. ":PrioritizedHooks:"
local maxPriority = 100000 -- This is the maximum priority that can be set. This is used to clamp the priority value.

function HookPS:Initialize(eventName, returns)
    self.Hooks = self.Hooks or {}
    self.Hooks[eventName] = self.Hooks[eventName] or {Ordered = {}, Returns = returns or {}}

    hook.Add(eventName, hookPrefix .. eventName, function(...)
        return self:Call(eventName, ...)
    end)
end

function HookPS:Add(eventName, name, func, priority) -- Add a bool to the end for isMergeable which will choose whether or not to merge the return values at the end.
    self:Initialize(eventName)

    priority = math.Clamp(priority or 0, -maxPriority, maxPriority)

    self.Hooks[eventName].Ordered[name] = {func = func, priority = priority}

    self:SortHooks(eventName)
end

function HookPS:Remove(eventName, name)
    if self.Hooks and self.Hooks[eventName] then
        self.Hooks[eventName].Ordered[name] = nil

        if table.IsEmpty(self.Hooks[eventName].Ordered) then
            hook.Remove(eventName, hookPrefix .. eventName)
            self.Hooks[eventName] = nil
        end
    end
end

function HookPS:SortHooks(eventName)
    if self.Hooks and self.Hooks[eventName] then
        local sorted = {}
        for name, data in pairs(self.Hooks[eventName].Ordered) do
            table.insert(sorted, {name = name, data = data})
        end
        table.sort(sorted, function(a, b) 
            return a.data.priority < b.data.priority
        end)
        local sortedNames = {}
        for i, hook in ipairs(sorted) do
            sortedNames[i] = hook.name
        end
        self.Hooks[eventName].OrderedSortedNames = sortedNames
    end
end

function HookPS:Call(eventName, ...)
    if self.Hooks and self.Hooks[eventName] then
        local originalArgs = {...}
        local previousReturn = {}

        -- Initialize the previousReturn with default values
        for name, value in pairs(self.Hooks[eventName].Returns) do
            if isvector(value) then
                previousReturn[name] = Vector(value.x, value.y, value.z)
            elseif isangle(value) then
                previousReturn[name] = Angle(value.pitch, value.yaw, value.roll)
            elseif isnumber(value) then
                previousReturn[name] = value
            else
                previousReturn[name] = nil
            end
        end

        -- Create a sorted list of hook names based on priority.
        local sortedNames = self.Hooks[eventName].OrderedSortedNames

        for _, name in ipairs(sortedNames) do
            local hook = self.Hooks[eventName].Ordered[name]

            -- Call the function with the original arguments and the previous return value as separate parameters.
            local newReturn = hook.func(originalArgs, previousReturn)

            -- Update the previousReturn with the newReturn values, keeping the defaults for nil values
            for key, value in pairs(newReturn) do
                if value ~= nil then
                    if isvector(previousReturn[key]) and isvector(value) then
                        previousReturn[key] = previousReturn[key] + value
                    elseif isangle(previousReturn[key]) and isangle(value) then
                        previousReturn[key] = previousReturn[key] + value
                    elseif isnumber(previousReturn[key]) and isnumber(value) then
                        previousReturn[key] = previousReturn[key] + value
                    else
                        previousReturn[key] = value
                    end
                end
            end
        end

        return previousReturn
    end
end