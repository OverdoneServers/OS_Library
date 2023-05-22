OverdoneServers.Modules = OverdoneServers.Modules or {}

OverdoneServers.ModuleMeta = OverdoneServers.ModuleMeta or include(OverdoneServers.LoaderDir .. "/shared/class_module.lua")

local lua_semver = OverdoneServers:GetLibrary("versioning")
function OverdoneServers:CompareVersions(v1, v2) -- Returns true if V1 is Greater or Equal to V2
    assert(isstring(v1) and isstring(v2), "Both Versions Must Be Strings!")
    return lua_semver(v1) >= lua_semver(v2)
end

local function GetModuleFilePaths()
    local ModuleFiles = {}

    for _, directory in ipairs(({file.Find(OverdoneServers.ModulesDir .. "/*", "LUA")})[2]) do
        local moduleFile = OverdoneServers.ModulesDir .. "/" .. directory .. "/" .. OverdoneServers.ModuleFile
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
        local type = string.lower(type)
        if type == "server" then -- TODO: Use the enum function
            type = OverdoneServers.ModuleLoadType.SERVER
        elseif type == "client" then
            type = OverdoneServers.ModuleLoadType.CLIENT
        elseif type == "shared" then
            type = OverdoneServers.ModuleLoadType.SHARED
        elseif type == "fonts" then
            type = OverdoneServers.ModuleLoadType.FONTS
        elseif type == "materials" then
            type = OverdoneServers.ModuleLoadType.MATERIALS
        else
            ErrorNoHalt("Error: " .. module.FolderName .. " has an invalid data type to load: " .. type .. "\n")
            continue
        end
        for _, f in ipairs(files) do
            if type != OverdoneServers.ModuleLoadType.MATERIALS and (not CLIENT or type != OverdoneServers.ModuleLoadType.SERVER) then
                OverdoneServers:PrintLoadingText(module, type)
            end
            
            if type == OverdoneServers.ModuleLoadType.FONTS then
                OverdoneServers:LoadFont(f, module.FontLocation)
            elseif type == OverdoneServers.ModuleLoadType.MATERIALS then
                if isstring(f) then
                    -- TODO: Make this add all files in the specified directory
                elseif istable(f) then
                    -- TODO: Make this add the specific file with resource.AddFile()
                end
            elseif not OverdoneServers:LoadLuaFile(module.FolderName, f, type) then
                returnValue = LoadModuleFail.LoadFileError
            end
        end
    end
    OverdoneServers:PrettyPrint(OverdoneServers.Loading.ModuleFooter)
    return LoadModuleFail.UnknownError
end

function OverdoneServers:LoadAllModules()
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
        OverdoneServers.Modules[module.FolderName] = module
        local failed = LoadModule(module)
        if failed == LoadModuleFail.NoDataToLoad then
            ErrorNoHalt("Error: " .. module.FolderName .. " has no data to load!\n")
            OverdoneServers.Modules[module.FolderName] = nil
        elseif failed == LoadModuleFail.LoadFileError then
            ErrorNoHalt("Error: " .. module.FolderName .. " failed to load!\n")
            OverdoneServers.Modules[module.FolderName] = nil
        end
    end

end