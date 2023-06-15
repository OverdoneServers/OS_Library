local LoginInfo = include(OverdoneServers.ConfigDir .. "/steamapi.lua")
local SteamAPIKey = LoginInfo.Enabled and LoginInfo.Key or nil
local APIBase = "https://api.steampowered.com"

OverdoneServers.SteamAPI = OverdoneServers.SteamAPI or {}

local function SendRequest(endpoint, parameters, callback)
    local url = APIBase .. endpoint .. "?key=" .. SteamAPIKey

    for k, v in pairs(parameters) do
        url = url .. "&" .. k .. "=" .. v
    end

    http.Fetch(url,
        function(body, len, headers, code)
            local data = util.JSONToTable(body)
            if not data then
                callback(false, "Failed to parse response")
                return
            end
            callback(true, data)
        end,
        function(err)
            callback(false, err)
        end
    )
end

function OverdoneServers.SteamAPI:GetPlayerSummaries(steamids, callback)
    if not istable(steamids) then
        steamids = {steamids}
    end

    SendRequest("/ISteamUser/GetPlayerSummaries/v2/", { steamids = table.concat(steamids, ",") },
        function(success, data)
            if success then
                if data and data.response and data.response.players then
                    callback(true, data.response.players)
                else
                    callback(false, nil)
                end
            else
                callback(false, data)
            end
        end
    )
end

function OverdoneServers.SteamAPI:GetOwnedGames(steamid, callback)
    SendRequest("/IPlayerService/GetOwnedGames/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetPlayerBans(steamid, callback)
    SendRequest("/ISteamUser/GetPlayerBans/v1/", { steamids = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetRecentlyPlayedGames(steamid, callback)
    SendRequest("/IPlayerService/GetRecentlyPlayedGames/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetUserGroupList(steamid, callback)
    SendRequest("/ISteamUser/GetUserGroupList/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetFriendList(steamid, callback)
    SendRequest("/ISteamUser/GetFriendList/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetGlobalAchievementPercentagesForApp(gameid, callback)
    SendRequest("/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v2/", { gameid = gameid }, callback)
end

function OverdoneServers.SteamAPI:GetUserStatsForGame(steamid, gameid, callback)
    SendRequest("/ISteamUserStats/GetUserStatsForGame/v2/", { steamid = steamid, appid = gameid }, callback)
end

function OverdoneServers.SteamAPI:GetPlayerAchievements(steamid, gameid, callback)
    SendRequest("/ISteamUserStats/GetPlayerAchievements/v1/", { steamid = steamid, appid = gameid }, callback)
end

function OverdoneServers.SteamAPI:GetSchemaForGame(gameid, callback)
    SendRequest("/ISteamUserStats/GetSchemaForGame/v2/", { appid = gameid }, callback)
end

function OverdoneServers.SteamAPI:GetPlayerLevel(steamid, callback)
    SendRequest("/IPlayerService/GetSteamLevel/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:IsPlayingSharedGame(steamid, gameid, callback)
    SendRequest("/IPlayerService/IsPlayingSharedGame/v1/", { steamid = steamid, appid_playing = gameid }, callback)
end

function OverdoneServers.SteamAPI:GetPlayerGameTime(steamid, gameid, callback)
    SendRequest("/IPlayerService/GetOwnedGames/v1/", { steamid = steamid, appids_filter = gameid, include_played_free_games = true, include_appinfo = true }, callback)
end

function OverdoneServers.SteamAPI:GetBadges(steamid, callback)
    SendRequest("/IPlayerService/GetBadges/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetCommunityBadgeProgress(steamid, callback)
    SendRequest("/IPlayerService/GetCommunityBadgeProgress/v1/", { steamid = steamid }, callback)
end

function OverdoneServers.SteamAPI:GetPlayerAppPlaytime(steamid, appid, callback)
    SendRequest("/IPlayerService/GetOwnedGames/v1/", { steamid = steamid, appids_filter = appid, include_played_free_games = true }, callback)
end

function OverdoneServers.SteamAPI:GetServerInfo(callback)
    SendRequest("/ISteamWebAPIUtil/GetServerInfo/v1/", {},
        function(success, data)
            if success then
                if data and data.response then
                    callback(true, data.response)
                else
                    callback(false, nil)
                end
            else
                callback(false, data)
            end
        end
    )
end

function OverdoneServers.SteamAPI:UpToDateCheck(appid, version, callback)
    SendRequest("/ISteamApps/UpToDateCheck/v1/", { appid = appid, version = version },
        function(success, data)
            if success then
                if data and data.response and data.response.success then
                    callback(true, data.response.success)
                else
                    callback(false, nil)
                end
            else
                callback(false, data)
            end
        end
    )
end

function OverdoneServers.SteamAPI:GetPlayerCount(appid, callback)
    SendRequest("/ISteamUserStats/GetNumberOfCurrentPlayers/v1/", { appid = appid }, callback)
end

function OverdoneServers.SteamAPI:GetPlayerNickname(steamid, callback)
    SendRequest("/ISteamUser/GetPlayerSummaries/v2/", { steamids = steamid },
        function(success, data)
            if success then
                if data and data.response and data.response.players then
                    callback(true, data.response.players[1].personaname)
                else
                    callback(false, nil)
                end
            else
                callback(false, data)
            end
        end
    )
end

function OverdoneServers.SteamAPI:GetBroadcastUploadToken(appid, steamid, callback)
    SendRequest("/IBroadcastService/GetBroadcastUploadToken/v1/", { appid = appid, steamid = steamid },
        function(success, data)
            if success then
                if data and data.response and data.response.broadcast_upload_token then
                    callback(true, data.response.broadcast_upload_token)
                else
                    callback(false, nil)
                end
            else
                callback(false, data)
            end
        end
    )
end