local config = include(OverdoneServers.ConfigDir .. "/steamapi.lua")

OverdoneServers.SteamAPIKey = config.Enabled and config.Key or nil