local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.Name = "Pointshop_1"

function CURRENCY:GetFunction(ply) 
    return ply:PS_GetPoints() //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount) 
    ply:PS_SetPoints(amount) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "$", ShowCommas = true} //Setting Defaults

OverdoneServers.Currencies:AddCurrency(CURRENCY.Name, CURRENCY) //Creates the currency