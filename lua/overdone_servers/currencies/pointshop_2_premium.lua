local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.name = "Pointshop_2:Premium"

function CURRENCY:GetFunction(ply)
    return ply.PS2_Wallet.premiumPoints //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount)
    ply:PS2_AddPremiumPoints(amount - self:GetFunction(ply)) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "$", ShowCommas = true} //Setting Defaults

return CURRENCY