local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.name = "SH_Pointshop:Standard"

function CURRENCY:GetFunction(ply)
    return ply:SH_GetStandardPoints() //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount)
    ply:SH_SetStandardPoints(amount) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "$", ShowCommas = true} //Setting Defaults

return CURRENCY