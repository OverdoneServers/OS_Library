
-- PrintTable(OverdoneServers.Libraries)

OverdoneServers.Libraries = {}

local function SortByLibraryLoadOrder(libraries)
    local sorted = {}
    local visited = {}

    local function getLibraryByName(name)
        for _, lib in pairs(libraries) do
            if lib.name == name then
                return lib
            end
        end
        return nil
    end

    local function visit(library, path)
        path = path or {}

        if visited[library.name] then
            return
        end

        if path[library.name] then
            Error("[ OverdoneServers ] Error: Cycle detected in library dependencies: " .. library.name)
            return
        end

        path[library.name] = true

        if library.Dependencies then
            for _, dependency in ipairs(library.Dependencies) do
                local dependent_library = getLibraryByName(dependency)

                if dependent_library then
                    visit(dependent_library, path)
                else
                    Error("[ OverdoneServers ] Error: Dependency " .. dependency .. " of library " .. library.name .. " not found!")
                    return
                end
            end
        end

        visited[library.name] = true
        table.insert(sorted, library)
    end

    for _, library in pairs(libraries) do
        visit(library)
    end

    return sorted
end

local LibraryState = {
    CLIENT = "client",
    SHARED = "shared",
    SERVER = "server"
}

local function SetupLibrary(name, state)
    if OverdoneServers.Libraries[name] then return end
    OverdoneServers.Libraries[name] = {}
    OverdoneServers.Libraries[name].name = name
    OverdoneServers.Libraries[name].state = state
    local library = include(OverdoneServers.LibrariesDir .. "/" .. state .. "/" .. name .. ".lua")
    if istable(library) then
        library.GlobalData = OverdoneServers.Libraries[name].GlobalData or {}
        OverdoneServers.Libraries[name].GlobalData = library.GlobalData -- Data is shared between all instances of the library
        OverdoneServers.Libraries[name].Dependencies = library.Dependencies
        OverdoneServers.Libraries[name]._initialize = library._initialize
        -- print("[ Library ] (" .. state .. ") Loaded: " .. name)
    else
        ErrorNoHalt("[ OS: Library ] (" .. state .. ") Failed to load: " .. name .. ". Library must return a table.")
    end
end

function OverdoneServers:GetLibrary(name)
    if not OverdoneServers.Libraries[name] then
        Error("[ OS: Library ] Error: Library does not exist: " .. name)
        return nil
    end
    local library = include(OverdoneServers.LibrariesDir .. "/" .. OverdoneServers.Libraries[name].state .. "/" .. name .. ".lua")
    library.GlobalData = OverdoneServers.Libraries[name].GlobalData
    return library
end

-- Send all files located in client/shared folder to client
for _, file in pairs(file.Find(OverdoneServers.LibrariesDir .. "/client/*", "LUA")) do
    if CLIENT then
        local name = string.lower(string.gsub(file, ".lua", ""))
        SetupLibrary(name, LibraryState.CLIENT)
    else
        AddCSLuaFile(OverdoneServers.LibrariesDir .. "/client/" .. file)
        print("[ OS: Library ] (client) Sending to client: " .. file)
    end
end

for _, file in pairs(file.Find(OverdoneServers.LibrariesDir .. "/shared/*", "LUA")) do
    AddCSLuaFile(OverdoneServers.LibrariesDir .. "/shared/" .. file)
    local name = string.lower(string.gsub(file, ".lua", ""))
    SetupLibrary(name, LibraryState.SHARED)
end

for _, file in pairs(file.Find(OverdoneServers.LibrariesDir .. "/server/*", "LUA")) do
    local name = string.lower(string.gsub(file, ".lua", ""))
    SetupLibrary(name, LibraryState.SERVER)
end

-- initialize all libraries
local sortedLibraries = SortByLibraryLoadOrder(OverdoneServers.Libraries)
print("Sorted is below")
PrintTable(sortedLibraries)
for _, library in ipairs(sortedLibraries) do
    if library._initialize then
        library:_initialize()
    end
    print("print msg is below")
    print(library)

    print("[ OS: Library ] (" .. tostring(library.state) .. ") Loaded: " .. tostring(library.name))
end