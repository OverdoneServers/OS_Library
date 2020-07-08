if OverdoneServers.IncludeData == nil then return end
local ModuleName, FilesToLoad = OverdoneServers.IncludeData.FolderName, OverdoneServers.IncludeData.FilesToLoad

for type, files in pairs(FilesToLoad) do
    for _, f in ipairs(files) do
            if type == "Server" and SERVER then
            OverdoneServers:LoadLuaFile(ModuleName, f, 1)
        elseif type == "Client" then
            OverdoneServers:LoadLuaFile(ModuleName, f, 2)
        elseif type == "Shared" then
            OverdoneServers:LoadLuaFile(ModuleName, f, 3)
        end
    end
end

OverdoneServers.IncludeData = nil
print("cool")
return true