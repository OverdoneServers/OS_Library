local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.name = "BaseWars"

function CURRENCY:GetFunction(ply) //Add the currency addon's function to return a player's balance here
    return ply:GetMoney()
end

function CURRENCY:SetFunction(ply, amount) //Add the currency addon's function to set a player's balance here
    ply:AddMoney(amount - self:GetFunction(ply))
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "$", ShowCommas = true} //Setting Defaults

return CURRENCY