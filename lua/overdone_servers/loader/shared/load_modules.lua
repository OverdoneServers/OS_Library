local files, dirs = file.Find(OverdoneServers.ModulesLocation .. "/*", "LUA")

for _, module in ipairs(dirs) do
    local ModuleDir = OverdoneServers.ModulesLocation .. "/" .. module
    if file.Exists(ModuleDir .. "/module.lua", "LUA") then
        include(ModuleDir .. "/module.lua")
    else
        ErrorNoHalt("Error: module.lua not found for " .. module .. "!\n") //TODO: change to pretty print
    end
end

for _, module in ipairs(OverdoneServers.Modules) do
    //TODO: Check if module is enabled here
    
    OverdoneServers.IncludeData = {name, filesToAdd}
    local loaded = include(OverdoneServers.LoaderDir .. "/shared/load.lua")

    OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
    if loaded then 
        OverdoneServers:PrettyPrint("////////////// Error Loading Module ///////////////")
    end
    OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
end