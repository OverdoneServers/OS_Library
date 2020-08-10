OverdoneServers.TableHelper = {}

function OverdoneServers.TableHelper:GetValue(table, ...) //Allows you to get a value wihin a table within a table (etc) while checking if its nil each time
    local args = {...}
    local tablePos = table

    for i=1, #args do
        if tablePos[args[i]] == nil then return nil end
        tablePos = tablePos[args[i]]
    end

    return tablePos
end

function OverdoneServers.TableHelper:SetValue(value, table, ...) //Allows you to set a value at a given positon in a table and will create the keys that are required
    local args = {...}
    local tablePos = table
    
    for i=1, #args do
        if tablePos[args[i]] == nil then tablePos[args[i]] = {} end
        if #args > i then
            tablePos = tablePos[args[i]]
        else
            tablePos[args[i]] = value
        end
    end
end