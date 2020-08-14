OverdoneServers.TableHelper = {}

function OverdoneServers.TableHelper:GetValue(tbl, ...) //Allows you to get a value wihin a table within a table (etc) while checking if its nil each time
    local args = {...}
    local tablePos = tbl

    for i=1, #args do
        if tablePos[args[i]] == nil then return nil end
        tablePos = tablePos[args[i]]
    end

    return tablePos
end

function OverdoneServers.TableHelper:SetValue(value, tbl, ...) //Allows you to set a value at a given positon in a table and will create the keys that are required
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

function OverdoneServers.TableHelper:InsertValue(value, tbl, ...) //Allows you to insert a value at a given positon in a table and will create the keys that are required
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