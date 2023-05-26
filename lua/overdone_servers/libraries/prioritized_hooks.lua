OverdoneServers.PrioritizedHooks = OverdoneServers.PrioritizedHooks or {}

local HookPS = OverdoneServers.PrioritizedHooks
local hookPrefix = OverdoneServers.LibraryModuleName .. ":PrioritizedHooks:"
local maxPriority = 100000 -- This is the maximum priority that can be set. This is used to clamp the priority value.

function HookPS:Initialize(eventName)
    self.Hooks = self.Hooks or {}
    self.Hooks[eventName] = self.Hooks[eventName] or {Ordered = {}, Layered = {}}

    hook.Add(eventName, hookPrefix .. eventName, function(...)
        local a,b = self:Call(eventName, ...)
        print("Got val: " .. tostring(a) .. " and ")
        PrintTable(b)
        return a
    end)
end

function HookPS:Add(eventName, name, func, priority, offset)
    self:Initialize(eventName)
    
    priority = priority or 0
    combineData = combineData or false -- Whether or not to combine the data from the layered hooks. If false, the data from the layered hooks will be discarded. (Can be table)
    chainData = chainData or false -- Whether or not to chain the data from the previous hook. If false, the data from the previous hook will be discarded. (Can be table)
    
    priority = math.Clamp(priority, -maxPriority, maxPriority)
    self.Hooks[eventName].Ordered[name] = {func = func, priority = priority, offset = offset or false}

    self:SortHooks(eventName)
end

function HookPS:AddLayered(eventName, name, func)
    self:Initialize(eventName)
    
    self.Hooks[eventName].Layered[name] = {func = func}
end

function HookPS:Remove(eventName, name)
    if self.Hooks and self.Hooks[eventName] then
        self.Hooks[eventName].Ordered[name] = nil
        self.Hooks[eventName].Layered[name] = nil

        if table.IsEmpty(self.Hooks[eventName].Ordered) and table.IsEmpty(self.Hooks[eventName].Layered) then
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
        local baseArgs = {...}
        local offsetArgs = {...}

        for _, name in ipairs(self.Hooks[eventName].OrderedSortedNames) do
            local hook = self.Hooks[eventName].Ordered[name]
            
            if hook.offset then
                local offset = {hook.func(unpack(baseArgs))}
                for i=1, #baseArgs do
                    if hook.offset == true or hook.offset[i] then
                        if offset[i] == nil then
                            -- Ignore this index if the offset is nil
                        elseif isnumber(offsetArgs[i]) and isnumber(offset[i]) then
                            offsetArgs[i] = offsetArgs[i] + offset[i]
                        elseif isvector(offsetArgs[i]) and isvector(offset[i]) then
                            offsetArgs[i] = offsetArgs[i] + offset[i]
                        elseif isangle(offsetArgs[i]) and isangle(offset[i]) then
                            offsetArgs[i].p = offsetArgs[i].p + offset[i].p
                            offsetArgs[i].y = offsetArgs[i].y + offset[i].y
                            offsetArgs[i].r = offsetArgs[i].r + offset[i].r
                        else
                            print("Error, tried to offset by type: " .. type(offsetArgs[i]) .. " and " .. type(offset[i]))
                        end
                    end
                end
            else
                baseArgs = {hook.func(unpack(offsetArgs))}
                offsetArgs = table.Copy(baseArgs)
            end
        end

        local layeredResults = {}
        for name, hook in pairs(self.Hooks[eventName].Layered) do
            table.insert(layeredResults, {hook.func(unpack(baseArgs))})
        end

        return unpack(baseArgs), layeredResults
    end
end
