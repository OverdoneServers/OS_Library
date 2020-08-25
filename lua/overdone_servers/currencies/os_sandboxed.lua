local OS_Sandboxed = {} //Creates a local currency that does NOT get saved anywhere.
local startBalance = 1000 //Sets the default balance people will have.



local CURRENCY = {} //Creates an empty table to be used for setting up the currency

function CURRENCY:Add(ply, amount) //Returns the new balance
    local newBal = (OS_Sandboxed[ply:SteamID64()] or startBalance) + amount
    OS_Sandboxed[ply:SteamID64()] = newBal
    return newBal
end

function CURRENCY:Take(ply, amount) //Returns how much money over, the amount tried to take from the player
    local leftOver = (OS_Sandboxed[ply:SteamID64()] or startBalance) - amount
    OS_Sandboxed[ply:SteamID64()] = math.Clamp(leftOver, 0, math.huge)
    return math.Clamp(-leftOver, -math.huge, 0) //TODO: may be positive leftOver
end

function CURRENCY:CanAfford(ply, amount) //Returns (bool) whether or not they can afford the amount and how much is required
    local has = OS_Sandboxed[ply:SteamID64()] or startBalance
    if amount == nil then return has end
    has = has - amount
    return has >= 0, math.Clamp(-has, 0, math.huge)
end

function CURRENCY:Balance(ply) //Returns the current balance 
    return OS_Sandboxed[ply:SteamID64()] or startBalance
end

function CURRENCY:Format(amount) //Returns a formated string of the amount.
    local amount = self.Settings.ShowCommas and string.Comma(amount) or amoun
    return self.Settings.signAtStart and (self.Settings.sign .. amount) or (amount .. self.Settings.sign)
end

CURRENCY.Settings = {signAtStart = true, sign = "$", ShowCommas = true} //Add any settings you want to be visable in the OS:Menu

OverdoneServers.Currencies:AddCurrency("os_sandboxed", CURRENCY) //Creates the currency with the name "os_sandboxed"