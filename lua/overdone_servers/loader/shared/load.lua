local ModuleName, FilesToLoad = OverdoneServers.IncludeData[1], OverdoneServers.IncludeData[2]
PrintTable(OverdoneServers.IncludeData)
print(ModuleName, FilesToLoad)

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

return true