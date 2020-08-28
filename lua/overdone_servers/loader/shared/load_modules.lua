AddCSLuaFile(OverdoneServers.LoaderDir .. "/shared/module.lua")

OverdoneServers.Modules = OverdoneServers.Modules or {}
OverdoneServers.Modules2Load = OverdoneServers.Modules2Load or {}

local files, dirs = file.Find(OverdoneServers.ModulesLocation .. "/*", "LUA")

for _, module in ipairs(dirs) do
    local ModuleDir = OverdoneServers.ModulesLocation .. "/" .. module
    local moduleFile = ModuleDir .. "/_module.lua"
    if file.Exists(moduleFile, "LUA") then
        --OverdoneServers.IncludeData = module
        AddCSLuaFile(moduleFile)
        include(moduleFile)
    else
        ErrorNoHalt("Error: _module.lua not found for " .. module .. "!\n") //TODO: change to pretty print
    end
end

local function CheckModules2Load()
    for k, module in pairs(OverdoneServers.Modules2Load) do
        
        local okayToLoad = true
        local missingThings = {}
        if module.Requires then
            if istable(module.Requires) then 
            elseif isstring(module.Requires) then
                module.Requires = {module.Requires}
            else
                OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
                OverdoneServers:PrettyPrint("//Error Loading Module.  Requirements Are Invalid//")
                OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
                OverdoneServers.Modules2Load[k] = nil
                continue
            end

            for _,req in ipairs(module.Requires) do
                if not OverdoneServers.Modules[req] then
                    if not OverdoneServers.Modules2Load[req] then
                        table.insert(missingThings, req)
                        okayToLoad = false
                        //print("MISSING", req)
                        continue
                    end
                    okayToLoad = false
                    //print("WAITING FOR", req)
                else
                    //print("FOUND", req)
                end
            end
        end

        local missingThingsCount = #missingThings
        if missingThingsCount > 0 then
            OverdoneServers:PrintLoadingText(module)
            OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")

            local message = missingThingsCount == 1 and "//     You are missing the following Module:     //\n" or "//     You are missing the following Modules:    //\n"
            local missingMsg = "// "
            for i,mis in ipairs(missingThings) do
                missingMsg = missingMsg .. mis
                if i != missingThingsCount then
                    missingMsg = missingMsg .. ", "
                end
            end
            missingMsg = missingMsg .. string.rep(" ", 49 - missingMsg:len()) .. "//"
            message = message .. missingMsg

            OverdoneServers:PrettyPrint("////////////// Error Loading Module ///////////////")
            OverdoneServers:PrettyPrint(message)
            OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
            OverdoneServers.Modules2Load[k] = nil
            continue
        end

        if not okayToLoad then continue end


        
        local loaded = OverdoneServers:LoadModule(module)

        OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
        if loaded == 1 then 
            OverdoneServers:PrettyPrint("////////////// Error Loading Module ///////////////")
        elseif loaded == 2 then
            OverdoneServers:PrettyPrint("//////////////// Missing DataToLoad ///////////////")
        else
            OverdoneServers.Modules[k] = module
        end
        OverdoneServers:PrettyPrint("///////////////////////////////////////////////////")
        OverdoneServers.Modules2Load[k] = nil
    end
end

CheckModules2Load()

local function BuildRefreshTimer() timer.Create("OverdoneServers:CheckModules2Load", 1, 0, CheckModules2Load) end
BuildRefreshTimer()

timer.Create("OverdoneServers:CheckModules2Load:Checker", 1, 0, function() //WARNING: sv_hibernate_think will have to be set to '1' in order to for modules to reload while players are offline. (This can be fixed by using a Coroutine)
    if not timer.Exists("OverdoneServers:CheckModules2Load") then
        print("An error has occored, please look above for the cause.\nModule(s) will try to load again in 30 seconds.")
        timer.Create("OverdoneServers:CheckModules2Load", 30, 1, BuildRefreshTimer)
    end
end)


--[[
print(coroutine.status(OverdoneServers.Modules2LoadCoroutine))
if OverdoneServers.Modules2LoadCoroutine and coroutine.status(OverdoneServers.Modules2LoadCoroutine) == "running" then
    coroutine.yield(OverdoneServers.Modules2LoadCoroutine)
end
OverdoneServers.Modules2LoadCoroutineSTOP = false
OverdoneServers.Modules2LoadCoroutine = coroutine.create(function()
    while true do
        print("yee")
        local endtime = CurTime() + 1
	    while true do
	    	if endtime < CurTime() then continue end
	    end
        if OverdoneServers.Modules2LoadCoroutineSTOP then
            print("stop!!!")
        end
        print("runnning")
    end
    --CheckModules2Load()
    --print("heee")
    --coroutine.yield()
    --print("aaaaa")
    print("yelo")
end)

timer.Simple(3, function()
    
    print("aaa")
    OverdoneServers.Modules2LoadCoroutineSTOP = true
    print("aaa")
end)
coroutine.resume(OverdoneServers.Modules2LoadCoroutine)
]]