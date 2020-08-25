local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.Name = "SH:Pointshop Standard"

function CURRENCY:GetFunction(ply) 
    ply:SH_GetStandardPoints() //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount) 
    ply:SH_SetStandardPoints(amount) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "$", ShowCommas = true} //Setting Defaults

---------- ADVANCED CONFIGURATION BELOW ----------

function CURRENCY:Add(ply, amount) //This should deposit an amount to the player's balance
    self:SetFunction(ply, self:Balance() + amount) //Add function to add the amount
    return self:Balance(ply) //Returns the new balance
end

function CURRENCY:Take(ply, amount) //This should withdraw amounts from the player's balance
    local leftOver = self:Balance(ply) - amount //How much is left over after the transaction?
    if not self.Settings.TakeIfOver and leftOver < 0 then //If true, then do not take the balance if the player cannot afford it
        return self:Balance(ply), math.Clamp(-leftOver, 0, math.huge)
    end
    self:SetFunction(ply, math.Clamp(leftOver, 0, math.huge)) //Function to set new amount from balance
    return self:Balance(ply), math.Clamp(-leftOver, 0, math.huge) //Returns balance, debt
end

function CURRENCY:CanAfford(ply, amount) //Uses Balance() and compares
    local has = self:Balance(ply)
    has = has - amount
    return has >= 0, math.Clamp(-has, 0, math.huge) //Returns bool, debt
end

function CURRENCY:Balance(ply) //Returns the player's current balance. Nothing else.
    return self:GetFunction(ply)
end

function CURRENCY:Format(amount) //Returns a formatted string of the amount.
    if isentity(amount) and amount:IsPlayer() then amount = self:Balance(amount) end
    local amount = self.Settings.ShowCommas and string.Comma(amount) or amoun
    return self.Settings.SignAtStart and (self.Settings.Sign .. amount) or (amount .. self.Settings.Sign)
end

OverdoneServers.Currencies:AddCurrency(CURRENCY.Name, CURRENCY) //Creates the currency



local CURRENCY = {} //Creates an empty table to be used for setting up the currency
CURRENCY.Name = "SH:Pointshop Premium"

function CURRENCY:GetFunction(ply) 
    ply:SH_GetPremiumPoints() //Add the currency addon's function to return a player's balance here
end

function CURRENCY:SetFunction(ply, amount) 
    ply:SH_SetPremiumPoints(amount) //Add the currency addon's function to set a player's balance here
end

CURRENCY.Settings = {TakeIfOver = true, SignAtStart = true, Sign = "☆", ShowCommas = true} //Setting Defaults


OverdoneServers.Currencies:AddCurrency(CURRENCY.Name, CURRENCY) //Creates the currency