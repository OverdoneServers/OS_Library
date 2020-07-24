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

OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_master_fonts.lua")

include(OverdoneServers.LoaderDir .. "/server/load_resources.lua")

OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_modules.lua")


print("Loaded Overdone Servers!!!")