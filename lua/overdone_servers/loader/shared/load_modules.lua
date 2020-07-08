local files, dirs = file.Find(OverdoneServers.ModulesLocation .. "/*", "LUA")

for _, module in ipairs(dirs) do
    local ModuleDir = OverdoneServers.ModulesLocation .. "/" .. module
    if file.Exists(ModuleDir .. "/_module.lua", "LUA") then
        --OverdoneServers.IncludeData = module
        include(ModuleDir .. "/_module.lua")
    else
        ErrorNoHalt("Error: module.lua not found for " .. module .. "!\n") //TODO: change to pretty print
    end
end

for _, module in pairs(OverdoneServers.Modules) do
    //TODO: Check if module is enabled here
    local loaded = OverdoneServers:LoadModule(module)

    OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
    if not loaded then 
        OverdoneServers:PrettyPrint("////////////// Error Loading Module ///////////////")
    end
    OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
end