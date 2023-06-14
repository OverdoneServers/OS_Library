OverdoneServers.MySQL = {}

local MySQL = OverdoneServers.MySQL

local LoginInfo = include(OverdoneServers.ConfigDir .. "/mysql.lua")

local mysqloo = nil

if (LoginInfo.Enabled) then
    mysqloo = require("mysqloo")
    if (mysqloo) then
        print("[ OverdoneServers ] MySQLoo was found!")
        
    else
        ErrorNoHalt("[ OverdoneServers ] MySQLoo is not installed! Cannot connect to MySQL!")
    end
end

function MySQL.Connect()
    if not mysqloo then
        print("MySQLoo not installed!")
        return
    end

    local db = mysqloo.connect(LoginInfo.Hostname, LoginInfo.Username, LoginInfo.Password, LoginInfo.Database, LoginInfo.Port)

    function db:onConnected()
        print("[ OverdoneServers ] MySQL Connected!")
    end

    function db:onConnectionFailed(err)
        ErrorNoHalt("[ OverdoneServers ] MySQL Connection failed! Error: " .. err)
    end

    db:connect()

    MySQL.DB = db

    return db
end

function MySQL.Query(query, callback)
    if not MySQL.DB then
        ErrorNoHalt("[ OverdoneServers ] Tried to send Query. However, MySQL is not connected!")
        return
    end

    local q = MySQL.DB:query(query)

    function q:onSuccess(data)
        if callback then
            callback(data)
        end
    end

    function q:onError(err)
        ErrorNoHalt("[ OverdoneServers ] MySQL Query failed! Error: " .. err)
    end

    q:start()

    return q
end

if (LoginInfo.Enabled) then
    MySQL.Connect() -- Attempt to connect on startup
end