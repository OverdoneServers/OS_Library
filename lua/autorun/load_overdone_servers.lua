OverdoneServers = {}
OverdoneServers.MainDir = "overdone_servers"
OverdoneServers.ModulesLocation = OverdoneServers.MainDir .. "/modules"
OverdoneServers.Modules = {}

if OverdoneServers.FinishedLoading then print("Reloading OverdoneServers") end

OverdoneServers.LoaderDir = OverdoneServers.MainDir .. "/loader"
include(OverdoneServers.LoaderDir .. "/shared/setup.lua")

include(OverdoneServers.LoaderDir .. "/shared/load_modules.lua")