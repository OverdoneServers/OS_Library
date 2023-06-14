local better_text = OverdoneServers:GetLibrary("better_text")
local table_helper = OverdoneServers:GetLibrary("table_helper")

OverdoneServers.ModuleLoadType = {
    UNKNOWN = 0/0,
    CUSTOM = 0,
    SERVER = 1,
    CLIENT = 2,
    SHARED = 3,
    FONTS = 4,

    FromString = function(str)
        return OverdoneServers.ModuleLoadType[string.upper(str)] or OverdoneServers.ModuleLoadType.CUSTOM
    end,
    ToString = function(type)
        return table_helper:FindKeyByValue(OverdoneServers.ModuleLoadType, type) or "CUSTOM"
    end
}

OverdoneServers.Loading.lastModule = "" -- Used for internal use only
OverdoneServers.Loading.lastType = OverdoneServers.ModuleLoadType.UNKNOWN -- Used for internal use only

function OverdoneServers:PrintLoadingText(module, type)
    local displayName = istable(module) and module.DisplayName or isstring(module) and module or "Invalid Name"

    if module != self.Loading.lastModule then
        self:PrettyPrint(OverdoneServers.Loading.ModuleHeader)
        self:PrettyPrint(
            OverdoneServers.Loading.ModuleVerticalLine ..
            better_text:AlignString(((istable(module) and module.FinishedLoading or nil) and "Reloading" or "Loading") ..
            " " ..
            (displayName or "Invalid Name"), OverdoneServers.ConsoleWidth-2, OverdoneServers.Loading.Align) ..
            (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
        )
        self:PrettyPrint(OverdoneServers.Loading.ModuleHeaderSeparator)
        if (istable(module)) then module.FinishedLoading = true end
        self.Loading.lastModule = module
        self.Loading.lastType = OverdoneServers.ModuleLoadType.UNKNOWN
    end

    if type != self.Loading.lastType then
        self:PrettyPrint(
            OverdoneServers.Loading.ModuleVerticalLine ..
            better_text:AlignString(OverdoneServers.ModuleLoadType.ToString(type), OverdoneServers.ConsoleWidth-2, OverdoneServers.Loading.Align) ..
            (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
        )
        self:PrettyPrint(OverdoneServers.Loading.ModuleDataSeparator)
        self.Loading.lastType = type
    end
end

function OverdoneServers:LoadLuaFile(moduleDirectory, fileName, moduleLoadType)
    local fileToLoadPath = OverdoneServers.ModulesDir .. "/" .. moduleDirectory .. "/"

        if moduleLoadType == OverdoneServers.ModuleLoadType.SERVER then -- TODO: use to string function in table
            fileToLoadPath = fileToLoadPath .. "server"
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.CLIENT then
            fileToLoadPath = fileToLoadPath .. "client"
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.SHARED then
            fileToLoadPath = fileToLoadPath .. "shared"
        end

        fileToLoadPath = fileToLoadPath .. "/" .. fileName

    local okay = true
    if not CLIENT then
        if not file.Exists(fileToLoadPath, "LUA") then
            fileName = fileName .. " - NOT FOUND"
            okay = false
        elseif file.Size(fileToLoadPath, "LUA") <= 0 then
            fileName = fileName .. " - EMPTY"
            okay = false
        end
    end
    if not CLIENT or moduleLoadType != OverdoneServers.ModuleLoadType.SERVER then
        OverdoneServers:PrettyPrint(
            OverdoneServers.Loading.ModuleVerticalLine ..
            better_text:AlignString("[ Initialize ]: " .. fileName, OverdoneServers.ConsoleWidth-2, TEXT_ALIGN_LEFT, OverdoneServers.Loading.Space) ..
            (OverdoneServers.Loading.Align == TEXT_ALIGN_LEFT and "" or OverdoneServers.Loading.ModuleVerticalLine)
        )
    end
    if okay then
        if moduleLoadType == OverdoneServers.ModuleLoadType.SERVER then
            if (SERVER) then include(fileToLoadPath) end
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.CLIENT then
            OverdoneServers:LoadClientFile(fileToLoadPath)
        elseif moduleLoadType == OverdoneServers.ModuleLoadType.SHARED then
            OverdoneServers:LoadSharedFile(fileToLoadPath)
        end
        return true
    else
        return false
    end
end

function OverdoneServers:FontLoadedMessage(name)
    self:PrettyPrint(
        self.Loading.ModuleVerticalLine ..
        better_text:AlignString("[ Adding Font ]: " .. name, self.ConsoleWidth-2, TEXT_ALIGN_LEFT) ..
        (self.Loading.Align == TEXT_ALIGN_LEFT and "" or self.Loading.ModuleVerticalLine)
    )
end