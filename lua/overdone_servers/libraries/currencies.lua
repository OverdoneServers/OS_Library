OverdoneServers.Currencies = {}
OverdoneServers.Currencies.Currencies = {}


function OverdoneServers.Currencies:AddCurrency(currencyName)
    self.Currencies[currencyName] = self.Currencies[currencyName] or {}
    return self.Currencies[currencyName]
end

function OverdoneServers.Currencies:GetCurrency(currencyName)
    return OverdoneServers.Currencies[currencyName]
end

function OverdoneServers.Currencies:Add(currencyName, ply, amount)
    if SERVER then
        local currencyData = OverdoneServers.Currencies[currencyName]
        if currencyData and isfunction(currencyData.Add) then
            return currencyData:Add(ply, amount)
        end
    end
end

function OverdoneServers.Currencies:Take(currencyName, ply, amount)
    if SERVER then
        local currencyData = OverdoneServers.Currencies[currencyName]
        if currencyData and isfunction(currencyData.Take) then
            return currencyData:Take(ply, amount)
        end
    end
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





--[[
OverdoneServers.Currencies:AddCurrency("SH:Pointshop Standard", {
    Add = function(ply, amount)
        local newBal = (OS_Sandboxed[ply:SteamID64()] or startBalance) + amount
        OS_Sandboxed[ply:SteamID64()] = newBal
        return newBal
    end,
    Take = function(ply, amount)
        local leftOver = (OS_Sandboxed[ply:SteamID64()] or startBalance) - amount
        OS_Sandboxed[ply:SteamID64()] = math.Clamp(leftOver, 0, math.huge)
        
        return math.Clamp(leftOver, -math.huge, 0)
    end,
    CanAfford = function(ply, amount)
        local has = OS_Sandboxed[ply:SteamID64()] or startBalance
        if amount == nil then return has end
        has = has - amount
        
        return has >= 0, math.Clamp(-has, 0, math.huge)
    end,
    Funds = function(ply)
        return OS_Sandboxed[ply:SteamID64()] or startBalance
    end,
    Format = function(amount)
        local amount = dontFormatWithCommas and amount or string.Comma(amount)
        return signAtStart and (sign .. amount) or (amount .. sign)
    end
})]]
--[[
for _,p in ipairs(player.GetHumans()) do
    local currency = OverdoneServers.Currencies:GetCurrency("os_sandboxed")

    print(p, "Funds: ", currency.Funds(p))
    print(p, "Added: ", currency.Add(p, 100))
    print(p, "Funds: ", currency.Funds(p))
    print(p, "Took: ", currency.Take(p, 500))
    print(p, "Funds: ", currency.Funds(p))
    print(p, "Can Afford: ", currency.CanAfford(p, 3000))
    print(p, "Formated Funds: ", currency.Format(currency.Funds(p)))
end
]]
