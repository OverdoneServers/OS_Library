if OverdoneServers then return end -- Disables this file from being reloaded. (Can cause lots of issues)
OverdoneServers = {}

OverdoneServers.MainDir = "overdone_servers"
OverdoneServers.ModulesDir = OverdoneServers.MainDir .. "/modules"
OverdoneServers.ModuleFile = "_module.lua"
OverdoneServers.LoaderDir = OverdoneServers.MainDir .. "/loader"
OverdoneServers.ConfigDir = OverdoneServers.MainDir .. "/configuration"
OverdoneServers.LibrariesDir = OverdoneServers.MainDir .. "/libraries"
OverdoneServers.CurrenciesDir = OverdoneServers.MainDir .. "/currencies"
OverdoneServers.LibraryModuleName = "Overdone Servers: Library"

-- Width that will be used to display module loading messages
OverdoneServers.ConsoleWidth = 60

if OverdoneServers.FinishedLoading then print("Reloading OverdoneServers") end

include(OverdoneServers.LoaderDir .. "/shared/setup.lua")

OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_libs.lua")

OverdoneServers:LoadClientFile(OverdoneServers.LoaderDir .. "/client/materials.lua")

if SERVER then
    -- Initialize database connection
    include(OverdoneServers.LoaderDir .. "/server/load_mysql.lua")

    -- Initialize steam api
    include(OverdoneServers.LoaderDir .. "/server/load_steamapi.lua")

    -- Initialize master networking
    include(OverdoneServers.LoaderDir .. "/server/networking.lua")
end

-- Load library fonts
OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_master_fonts.lua")

if SERVER then
    -- Load all resources (materials, sounds, etc)
    include(OverdoneServers.LoaderDir .. "/server/load_resources.lua")
end

-- Initalize permission system
OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/permissions.lua")

-- Initalize module loading functions
OverdoneServers:LoadSharedFile(OverdoneServers.LoaderDir .. "/shared/load_modules.lua")

-- Print footer for Library Module
OverdoneServers:PrettyPrint(OverdoneServers.Loading.ModuleFooter)

-- Load all modules
OverdoneServers:LoadAllModules()

print("Loaded Overdone Servers!!!")