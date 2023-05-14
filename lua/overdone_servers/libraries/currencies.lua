OverdoneServers.Currencies = {}

function OverdoneServers.Currencies:AddCurrency(currencyName, data)
    OverdoneServers.Currencies:AddDefaultMeta(data)
    OverdoneServers.Currencies[currencyName] = data
    return OverdoneServers.Currencies[currencyName]
end

function OverdoneServers.Currencies:GetCurrency(currencyName)
    return OverdoneServers.Currencies[currencyName]
end

function OverdoneServers.Currencies:Add(currencyName, ply, amount)
    local currencyData = OverdoneServers.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Add) then
        return currencyData:Add(ply, amount)
    end
    return nil
end

function OverdoneServers.Currencies:Take(currencyName, ply, amount)
    local currencyData = OverdoneServers.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Take) then
        return currencyData:Take(ply, amount)
    end
    return nil
end

function OverdoneServers.Currencies:CanAfford(currencyName, ply, amount)
    local currencyData = OverdoneServers.Currencies[currencyName]
    if currencyData and isfunction(currencyData.CanAfford) then
        return currencyData:CanAfford(ply, amount)
    end
    return nil
end

function OverdoneServers.Currencies:Balance(currencyName, ply)
    local currencyData = OverdoneServers.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Balance) then
        return currencyData:Balance(ply, amount)
    end
    return nil
end

function OverdoneServers.Currencies:Format(currencyName, amount)
    local currencyData = OverdoneServers.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Format) then
        return currencyData.Format(amount)
    end
    return nil
end

local DefaultMeta = {}
function DefaultMeta:Add(ply, amount) //This should deposit an amount to the player's balance
    if SERVER then
        self:SetFunction(ply, self:Balance(ply) + amount) //Add function to add the amount
        return self:Balance(ply) //Returns the new balance
    end
    return nil
end

function DefaultMeta:Take(ply, amount) //This should withdraw amounts from the player's balance
    if SERVER then
        local leftOver = self:Balance(ply) - amount //How much is left over after the transaction?
        if not self.Settings.TakeIfOver and leftOver < 0 then //If true, then do not take the balance if the player cannot afford it
            return self:Balance(ply), math.Clamp(-leftOver, 0, math.huge)
        end
        self:SetFunction(ply, math.Clamp(leftOver, 0, math.huge)) //Function to set new amount from balance
        return self:Balance(ply), math.Clamp(-leftOver, 0, math.huge) //Returns balance, debt
    end
    return nil
end

function DefaultMeta:CanAfford(ply, amount) //Uses Balance() and compares
    local has = self:Balance(ply)
    has = has - amount
    return has >= 0, math.Clamp(-has, 0, math.huge) //Returns bool, debt
end

function DefaultMeta:Balance(ply) //Returns the player's current balance. Nothing else.
    return self:GetFunction(ply)
end

function DefaultMeta:Format(amount) //Returns a formatted string of the amount.
    if isentity(amount) and amount:IsPlayer() then amount = self:Balance(amount) end
    local amount = self.Settings.ShowCommas and string.Comma(amount) or amount
    return self.Settings.SignAtStart and (self.Settings.Sign .. amount) or (amount .. self.Settings.Sign)
end

function OverdoneServers.Currencies:AddDefaultMeta(tbl)
    OverdoneServers:AddMetaTable(tbl, DefaultMeta)
end

OverdoneServers:WaitForTicks(3, function()
    for _, fileName in ipairs(file.Find(OverdoneServers.MainDir .. "/currencies" .. "/*.lua", "LUA")) do
        local currencyFile = OverdoneServers.MainDir .. "/currencies" .. "/" .. fileName
        if CLIENT or file.Size(currencyFile, "LUA") > 0 then
            AddCSLuaFile(currencyFile)
            include(currencyFile)
        else
            ErrorNoHalt("Error: Currency file EMPTY for \"" .. fileName .. "\"!\n") //TODO: change to pretty print
        end
    end
end)

--[[

timer.Simple(3, function()
    local currency = OverdoneServers.Currencies:GetCurrency("SH_PointshopStandard")
    for _,ply in ipairs(player.GetHumans()) do
        print(ply, "Current", currency:Format(currency:Balance(ply)))
        print(ply, "Add", tostring(currency:Add(ply, 100)))
        print(ply, "Current", currency:Format(currency:Balance(ply)))
        print(ply, "Take", currency:Take(ply, 1234))
        print(ply, "Current", currency:Format(currency:Balance(ply)))
        print(ply, "CanAfford '500'", currency:CanAfford(ply, 500))
        print(ply, "CanAfford '1000'", currency:CanAfford(ply, 1000))
        print(ply, "CanAfford '1000000000000'", currency:CanAfford(ply, 1000000000000))
        print(ply, "Current", currency:Format(currency:Balance(ply)))
    end
end)

]]