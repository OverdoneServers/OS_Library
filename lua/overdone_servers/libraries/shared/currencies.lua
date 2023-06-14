local Currency = {}

Currency.__index = Currency

function Currency:GetFunction(ply) return 0 end
function Currency:SetFunction(ply, amount) end

function Currency:Add(ply, amount) --This should deposit an amount to the player's balance
    if SERVER then
        self:SetFunction(ply, self:Balance(ply) + amount) --Add function to add the amount
        return self:Balance(ply) --Returns the new balance
    end
    return nil
end

function Currency:Take(ply, amount) --This should withdraw amounts from the player's balance
    if SERVER then
        local leftOver = self:Balance(ply) - amount --How much is left over after the transaction?
        if not self.Settings.TakeIfOver and leftOver < 0 then --If true, then do not take the balance if the player cannot afford it
            return self:Balance(ply), math.Clamp(-leftOver, 0, math.huge)
        end
        self:SetFunction(ply, math.Clamp(leftOver, 0, math.huge)) --Function to set new amount from balance
        return self:Balance(ply), math.Clamp(-leftOver, 0, math.huge) --Returns balance, debt
    end
    return nil
end

function Currency:CanAfford(ply, amount) --Uses Balance() and compares
    local has = self:Balance(ply)
    has = has - amount
    return has >= 0, math.Clamp(-has, 0, math.huge) --Returns bool, debt
end

function Currency:Balance(ply) --Returns the player's current balance. Nothing else.
    return self:GetFunction(ply)
end

function Currency:Format(amount) --Returns a formatted string of the amount.
    if isentity(amount) and amount:IsPlayer() then amount = self:Balance(amount) end
    local amount = self.Settings.ShowCommas and string.Comma(amount) or amount
    return self.Settings.SignAtStart and (self.Settings.Sign .. amount) or (amount .. self.Settings.Sign)
end

---------------------------------------------------------------------------------

local Currencies = {}

function Currencies:_initialize()
    Currencies.GlobalData.Currencies = Currencies.GlobalData.Currencies or {}

    for _, file in ipairs(file.Find(OverdoneServers.MainDir .. "/Currencies/*.lua", "LUA")) do
        local currencyFile = OverdoneServers.MainDir .. "/Currencies/" .. file
        local currencyData = include(currencyFile)
        if istable(currencyData) then
            Currencies:AddCurrency(currencyData)
        else
            ErrorNoHalt("[ OS: Currencies ] Error: Currency file \"" .. file .. "\" did not return a table!\n")
        end
    end
end

function Currencies:AddCurrency(data)
    setmetatable(data, Currency)
    Currencies.GlobalData.Currencies[data.name] = data
    print("[ OS: Currencies ] Added currency \"" .. data.name .. "\"")
end

function Currencies:GetCurrency(currencyName)
    return Currencies.GlobalData.Currencies[currencyName]
end

function Currencies:Add(currencyName, ply, amount)
    local currencyData = Currencies.GlobalData.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Add) then
        return currencyData:Add(ply, amount)
    end
    return nil
end

function Currencies:Take(currencyName, ply, amount)
    local currencyData = Currencies.GlobalData.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Take) then
        return currencyData:Take(ply, amount)
    end
    return nil
end

function Currencies:CanAfford(currencyName, ply, amount)
    local currencyData = Currencies.GlobalData.Currencies[currencyName]
    if currencyData and isfunction(currencyData.CanAfford) then
        return currencyData:CanAfford(ply, amount)
    end
    return nil
end

function Currencies:Balance(currencyName, ply)
    local currencyData = Currencies.GlobalData.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Balance) then
        return currencyData:Balance(ply, amount)
    end
    return nil
end

function Currencies:Format(currencyName, amount)
    local currencyData = Currencies.GlobalData.Currencies[currencyName]
    if currencyData and isfunction(currencyData.Format) then
        return currencyData.Format(amount)
    end
    return nil
end

return Currencies