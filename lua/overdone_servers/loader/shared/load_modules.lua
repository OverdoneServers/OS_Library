OverdoneServers.Modules = OverdoneServers.Modules or {}

OverdoneServers.ModuleMeta = OverdoneServers.ModuleMeta or include(OverdoneServers.LoaderDir .. "/shared/class_module.lua")

local lua_semver = OverdoneServers:GetLibrary("versioning")
function OverdoneServers:CompareVersions(v1, v2) -- Returns true if V1 is Greater or Equal to V2
    assert(isstring(v1) and isstring(v2), "Both Versions Must Be Strings!")
    return lua_semver(v1) >= lua_semver(v2)
end

local function GetModuleFilePaths()
    local ModuleFiles = {}

    for _, directory in ipairs(({file.Find(OverdoneServers.ModulesLocation .. "/*", "LUA")})[2]) do
        local moduleFile = OverdoneServers.ModulesLocation .. "/" .. directory .. "/" .. OverdoneServers.ModuleFile
        if (({file.Find(moduleFile, "LUA")})[1][1] != nil) then
            ModuleFiles[directory] = moduleFile
        end
    end

    return ModuleFiles
end

local function SortByModuleLoadOrder(modules)
    local visited, resolved, visiting = {}, {}, {}
    
    local function visit(module)
        if visited[module] then return end
        if visiting[module] then return false end

        visiting[module] = true

        local function handleDependencies(dependencies, isSoftDepend)
            local allDependenciesSatisfied = true
            for _,dependency in ipairs(dependencies) do
                if isstring(dependency) then
                    dependency = {dependency}
                end

                local dependent_module = nil
                for _,module in ipairs(modules) do
                    if module.FolderName == dependency[1] then
                        dependent_module = module
                        break
                    end
                end

                if dependent_module then
                    if dependency[2] and not OverdoneServers:CompareVersions(dependent_module.Version, dependency[2]) then
                        if isSoftDepend then
                            print("Soft Dependency " .. module.FolderName .. " requires " .. dependent_module.FolderName .. " v" .. dependency[2] .. " or higher!\n")
                        else
                            ErrorNoHalt("Error: " .. module.FolderName .. " requires " .. dependent_module.FolderName .. " v" .. dependency[2] .. " or higher!\n")
                            allDependenciesSatisfied = false
                        end
                    else
                        allDependenciesSatisfied = allDependenciesSatisfied and visit(dependent_module)
                    end
                elseif not isSoftDepend then
                    ErrorNoHalt("Error: " .. module.FolderName .. " requires " .. dependency[1] .. " but it is not loaded!\n")
                    allDependenciesSatisfied = false
                end
            end
            return allDependenciesSatisfied
        end

        local allDependenciesSatisfied = true
        if istable(module.Dependencies) then -- TODO: Change to depends
            allDependenciesSatisfied = allDependenciesSatisfied and handleDependencies(module.Dependencies, false)
        end
        if istable(module.SoftDependencies) then -- TODO: Change to softdepends
            allDependenciesSatisfied = allDependenciesSatisfied and handleDependencies(module.SoftDependencies, true)
        end

        visiting[module] = false
        visited[module] = true

        if allDependenciesSatisfied then
            table.insert(resolved, module)
        end

        return allDependenciesSatisfied
    end

    for _,module in ipairs(modules) do
        visit(module)
    end
    return resolved
end

local LoadModuleFail = {
    UnknownError = 0,
    NoDataToLoad = 1,
    LoadFileError = 2,
    LoadFileSuccess = 3
}

local function LoadModule(module)
    local returnValue = LoadFileSuccess

    if not istable(module.DataToLoad) or table.IsEmpty(module.DataToLoad) then OverdoneServers:PrintLoadingText(module) return LoadModuleFail.NoDataToLoad end

    for type, files in pairs(istable(module.DataToLoad) and module.DataToLoad or {}) do
        for _, f in ipairs(files) do
            if (not CLIENT or type != "Server") and type != "Materials" then
                OverdoneServers:PrintLoadingText(module, type)
            end
            
            if type == "Server" and SERVER then
                if not OverdoneServers:LoadLuaFile(module.FolderName, f, OverdoneServers.ModuleLoadType.SERVER) then returnValue = LoadModuleFail.LoadFileError end
            elseif type == "Client" then
                if not OverdoneServers:LoadLuaFile(module.FolderName, f, OverdoneServers.ModuleLoadType.CLIENT) then returnValue = LoadModuleFail.LoadFileError end
            elseif type == "Shared" then
                if not OverdoneServers:LoadLuaFile(module.FolderName, f, OverdoneServers.ModuleLoadType.SHARED) then returnValue = LoadModuleFail.LoadFileError end
            elseif type == "Fonts" then
                OverdoneServers:LoadFont(f, module.FontLocation)
            elseif type == "Materials" then
                if isstring(f) then
                    -- TODO: Make this add all files in the specified directory
                elseif istable(f) then
                    -- TODO: Make this add the specific file with resource.AddFile()
                end
            end
        end
    end
    return LoadModuleFail.UnknownError
end

local function StartLoadingModules()
    local QueuedModules = {}

    for directory, moduleFile in pairs(GetModuleFilePaths()) do
        AddCSLuaFile(moduleFile)
        local module = include(moduleFile)
        if istable(module) then
            table.insert(QueuedModules, OverdoneServers.ModuleMeta.new(module, directory))
        else
            ErrorNoHalt("Error: _module.lua for " .. directory .. " did not return a table!\n")
        end
    end

    QueuedModules = SortByModuleLoadOrder(QueuedModules)

    for _,module in ipairs(QueuedModules) do
        local failed = LoadModule(module)
        if failed == LoadModuleFail.NoDataToLoad then
            ErrorNoHalt("Error: " .. module.FolderName .. " has no data to load!\n")
        elseif failed == LoadModuleFail.LoadFileError then
            ErrorNoHalt("Error: " .. module.FolderName .. " failed to load!\n")
        end
    end

end

StartLoadingModules()