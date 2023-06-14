local startBalance = 1000 //Sets the default balance people will have.

local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.name = "OS_Sandboxed"

function CURRENCY:GetFunction(ply)
    return ply:GetNWInt("OverdoneServers:Currency:OS_Sandboxed", startBalance) //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount)
    ply:SetNWInt("OverdoneServers:Currency:OS_Sandboxed", amount)
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = false, Sign = "ꬶ", ShowCommas = true} //Setting Defaults

return CURRENCY