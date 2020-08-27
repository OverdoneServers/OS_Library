local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.Name = "SH_Pointshop:Standard"

function CURRENCY:GetFunction(ply) 
    return ply:SH_GetStandardPoints() //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount) 
    ply:SH_SetStandardPoints(amount) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "$", ShowCommas = true} //Setting Defaults

OverdoneServers.Currencies:AddCurrency(CURRENCY.Name, CURRENCY) //Creates the currency



local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.Name = "SH_Pointshop:Premium"

function CURRENCY:GetFunction(ply) 
    return ply:SH_GetPremiumPoints() //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount) 
    ply:SH_SetPremiumPoints(amount) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "☆", ShowCommas = true} //Setting Defaults


OverdoneServers.Currencies:AddCurrency(CURRENCY.Name, CURRENCY) //Creates the currency