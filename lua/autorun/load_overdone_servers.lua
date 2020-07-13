OverdoneServers = {}

OverdoneServers.MainDir = "overdone_servers"
OverdoneServers.ModulesLocation = OverdoneServers.MainDir .. "/modules"
OverdoneServers.LoaderDir = OverdoneServers.MainDir .. "/loader"
OverdoneServers.ConfigDir = OverdoneServers.MainDir .. "/configuration"
OverdoneServers.LibrariesDir = OverdoneServers.MainDir .. "/libraries"

OverdoneServers.Modules = {}

if OverdoneServers.FinishedLoading then print("Reloading OverdoneServers") end

include(OverdoneServers.LoaderDir .. "/shared/setup.lua")

OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_libs.lua")

if SERVER then
    include(OverdoneServers.LoaderDir .. "/server/load_mysql.lua")
    include(OverdoneServers.LoaderDir .. "/server/load_steamapi.lua")
end

OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_modules.lua")

print("Loaded Overdone Servers!!!")

local a,b,c = .3,0,10

print("Linear", OverdoneServers.EaseFunctions:Linear(a,b,c))

print("Spring", OverdoneServers.EaseFunctions:Spring(a,b,c))