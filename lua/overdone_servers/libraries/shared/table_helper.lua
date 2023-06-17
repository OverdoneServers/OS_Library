local TableHelper = {}

function TableHelper:GetValue(tbl, ...) --Allows you to get a value wihin a table within a table (etc) while checking if its nil each time
    local args = {...}
    local tablePos = tbl

    for i=1, #args do
        if tablePos[args[i]] == nil then return nil end
        tablePos = tablePos[args[i]]
    end

    return tablePos
end

function TableHelper:SetValue(value, tbl, ...) --Allows you to set a value at a given positon in a table and will create the keys that are required
    local args = {...}
    local tablePos = tbl

    for i=1, #args do
        if tablePos[args[i]] == nil then tablePos[args[i]] = {} end
        if #args > i then
            tablePos = tablePos[args[i]]
        else
            tablePos[args[i]] = value
        end
    end
end

function TableHelper:InsertValue(value, tbl, ...) --Allows you to insert a value at a given positon in a table and will create the keys that are required
    local args = {...}
    local tablePos = tbl

    for i=1, #args do
        if tablePos[args[i]] == nil then tablePos[args[i]] = {} end
        if #args > i then
            tablePos = tablePos[args[i]]
        else
            return table.insert(tablePos[args[i]], value)
        end
    end
end

function TableHelper:HasValue(tbl, val) --Unlike the default table.HasValue() function, it will return the key where the value was found and will return nil otherwise
    for k, v in pairs(tbl) do
        if (v == val) then return k end
    end
    return nil
end

function TableHelper:RemoveIfFound(tbl, val) --Removes value if found
    local key = self:HasValue(tbl, val)
    if key != nil then
        table.RemoveByValue(tbl, val)
        return key
    end
    return nil
end

function TableHelper:RemoveValThenAdd(tbl, val) --Removes value if found then adds to end of table
    local found = TableHelper:RemoveIfFound(tbl, val) != nil
    local pos = table.insert(tbl, val)
    return pos, found
end

function TableHelper:Purge(tbl1, tbl2) --Removes value if found in the other table. Returns what keys were removed from table1 (in ipairs) and how big that table is
    local vals = {}

    for _,v in pairs(tbl2) do
        vals[v] = true
    end

    local keysRemoved = {}
    local count = 0 --Allows you to not use table.Count() (aka faster since your counting while building the table)

    for k,v in pairs(tbl1) do
        if vals[v] then
            table.insert(keysRemoved, k)
            count = count + 1
            tbl1[k] = nil
        end
    end

    return keysRemoved, count
end

function TableHelper:FindKeyByValue(tbl, targetValue)
    for key, value in pairs(tbl) do
        if value == targetValue then
            return key
        end
    end
    return nil
end

function TableHelper:FindKeysByValue(tbl, targetValue)
    local keys = {}
    for key, value in pairs(tbl) do
        if value == targetValue then
            table.insert(keys, key)
        end
    end
    return keys
end

return TableHelper