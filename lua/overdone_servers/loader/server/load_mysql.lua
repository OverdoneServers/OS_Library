local LoginInfo = include(OverdoneServers.ConfigDir .. "/sql.lua")

if not OverdoneServers.Database then
    if (LoginInfo.Enabled) then
        local success = pcall(require, "mysqloo")
        if (not success) then
            ErrorNoHalt("[ OverdoneServers ] MySQLoo is not installed! Cannot connect to SQL!")
        end
    end

    OverdoneServers.Database = {}
end

function OverdoneServers.Database:Connect()
    if not mysqloo then
        print("MySQLoo not installed!")
        return
    end

    if (self.DB and self.DB:status() == mysqloo.DATABASE_CONNECTED) then
        print("[ OverdoneServers ] SQL is already connected!")
        return
    end

    local db = mysqloo.connect(LoginInfo.Hostname, LoginInfo.Username, LoginInfo.Password, LoginInfo.Database, LoginInfo.Port)

    function db.onConnected()
        print("[ OverdoneServers ] SQL Connected!")
    end

    function db.onConnectionFailed(err)
        ErrorNoHalt("[ OverdoneServers ] SQL Connection failed! Error: ", err)
    end

    print("[ OverdoneServers ] Connecting to SQL...")
    db:connect()

    self.DB = db

    return db
end

function OverdoneServers.Database:Query(query, successCallback, errorCallback)
    if not self.DB or self.DB:status() != mysqloo.DATABASE_CONNECTED then
        if isfunction(errorCallback) then
            errorCallback("SQL is not connected!")
        else
            ErrorNoHalt("[ OverdoneServers ] Tried to send Query. However, SQL is not connected!")
        end
        return
    end

    local q = self.DB:query(query)

    function q:onSuccess(data)
        if isfunction(successCallback) then
            successCallback(data)
        end
    end

    function q:onError(err)
        if isfunction(errorCallback) then
            errorCallback(err)
        else
            ErrorNoHalt("[ OverdoneServers ] SQL Query failed!\n", err, "\n")
        end
    end

    q:start()

    return q
end

if (LoginInfo.Enabled and (not OverdoneServers.Database.DB or OverdoneServers.Database.DB:status() != mysqloo.DATABASE_CONNECTED)) then
    OverdoneServers.Database:Connect()
end