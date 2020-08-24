OverdoneServers.Permissions = {}

//DefaultRank must be "user", "admin", or "superadmin"
if SERVER then
    local function SendToClient(permission, defaultRank, displayName)
        net.Start("OverdoneServers:Permissions:SendPerms")
        net.WriteBit(0)
        net.WriteString(permission)
        net.WriteString(defaultRank)
        net.WriteString(displayName)
        net.Broadcast()
    end

    function OverdoneServers:AddPermission(permission, defaultRank, displayName)
        OverdoneServers:WaitForTicks(3, function()

            if not (isstring(permission) or isstring(defaultRank) or isstring(displayName)) then
                error("Overdone Servers: Permission failed to add.\n" ..
                "Permission: " .. tostring(permission) .. "\n" ..
                "DefaultRank: " .. tostring(defaultRank) .. "\n" ..
                "DisplayName: " .. tostring(displayName))
                return
            end

            if defaultRank != "user" and defaultRank != "admin" and defaultRank != "superadmin" then 
                error("Overdone Servers: Permission failed to add.\n" ..
                "Permission: " .. tostring(permission) .. "\n" ..
                "DefaultRank: " .. tostring(defaultRank) .. "\n" ..
                "DisplayName: " .. tostring(displayName) .. "\n\n" .. 
                "DefaultRank must be \"user\", \"admin\", or \"superadmin\"")
                return 
            end

            OverdoneServers.Permissions[permission] = defaultRank

            if sam then
                sam.permissions.add(permission, "Overdone Servers", defaultRank)
                SendToClient(permission, defaultRank, displayName)
                print("Overdone Servers: Added Permission using SAM.", permission)
            elseif xAdmin == nil and false or (xAdmin["RegisterPermission"] ~= nil and xAdmin["RegisterCategory"] ~= nil and xAdmin["Config"] ~= nil and xAdmin.Config["Name"] ~= nil) then //Support for the free github xAdmin is done in CAMI
                xAdmin.RegisterPermission(permission, displayName, "Overdone Servers")
                print("Overdone Servers: Added Permission using xAdmin.", permission)
    
            elseif ULib then //ULX Support, not tested
                local perm =
                    defaultRank == "user"       and ULib.ACCESS_ALL         or 
                    defaultRank == "operator"   and ULib.ACCESS_OPERATOR    or
                    defaultRank == "admin"      and ULib.ACCESS_ADMIN       or 
                    defaultRank == "superadmin" and ULib.ACCESS_SUPERADMIN  or
                    nil

                if perm == nil then
                    error("Overdone Servers: Permission failed to add.\n" .. "Invalid ULX Default Given")
                    return
                end
                ULib.ucl.registerAccess(permission, perm, displayName, "Overdone Servers")
                
                print("Overdone Servers: Added Permission using ULib.", permission)

            elseif evolve then //Not tested
			    table.insert(evolve.privileges, permission)

                defaultRank = defaultRank == "user" and "guest" or defaultRank

			    table.insert(evolve.ranks[access[default_access]].Privileges, permission)

			    if default_access == "user" then
			    	table.insert(evolve.ranks.respected.Privileges, permission)
			    	table.insert(evolve.ranks.admin.Privileges, permission)
			    	table.insert(evolve.ranks.superadmin.Privileges, permission)
			    end
			    if default_access == "admin" then
			    	table.insert(evolve.ranks.superadmin.Privileges, permission)
			    end
            elseif serverguard then //Not tested
			    function registerSGPerm(unique, permission)
			    	local permissions = serverguard.ranks:GetData(unique, "Permissions", {})
			    	permissions[permission] = true

			    	serverguard.ranks:SetData(unique, "Permissions", permissions)
			    	serverguard.netstream.Start(nil, "sgNetworkRankData", {unique, "Permissions", permissions})
			    	serverguard.ranks:SaveTable(unique)
			    end

			    registerSGPerm(defaultRank, permission)

			    if default_access == "user" then
			    	registerSGPerm("admin", permission)
			    	registerSGPerm("superadmin", permission)
			    end
			    if default_access == "admin" then
			    	registerSGPerm("superadmin", permission)
			    end
            elseif CAMI then //Operational
                CAMI.RegisterPrivilege({Name = permission, MinAccess = defaultRank, callback = function() end, Description = displayName})
                
                print("Overdone Servers: Added Permission using CAMI.", permission)
            else
                
                print("Overdone Servers: Added Permission using NOTHING.", permission)
            end
        end)
    end

    hook.Add("OverdoneServers:PlayerReady", "OS:Permissions:SendPermsToClient", function(ply)
        net.Start("OverdoneServers:Permissions:SendPerms")
        net.WriteBit(1)
        net.WriteTable(OverdoneServers.Permissions)
        net.Send(ply)
    end)
end

function OverdoneServers:HasPermission(ply, permission)
    if not IsValid(ply) then return nil end
    if not isstring(permission) then
        error("Overdone Servers: Failed to check if player has permission.\n" ..
        "Permission: " .. tostring(permission))
        return nil
    end

    if sam then
        return ply:HasPermission(permission) == true
    elseif xAdmin == nil and false or (xAdmin["RegisterPermission"] ~= nil and xAdmin["RegisterCategory"] ~= nil and xAdmin["Config"] ~= nil and xAdmin.Config["Name"] ~= nil) then //Support for the free github xAdmin is done in CAMI
        return ply:xAdminHasPermission(permission) == true
    elseif ULib then
        return ULib.ucl.query(ply, permission) == true
    elseif serverguard then
		return serverguard.player:HasPermission(ply, permission) == true
	elseif evolve then
		return ply:EV_HasPrivilege(permission) == true
    elseif CAMI then
        local r = CAMI.PlayerHasAccess(ply, permission)
        return r == true
    else
        local defaultPerm = OverdoneServers.Permissions[permission]
        local plyPerm = ply:GetUserGroup()

        if ply:IsAdmin() and defaultPerm == "admin" then return true end
        if plyPerm == "superadmin" and defaultPerm == "superadmin" then return true end

        return defaultPerm == "user"
    end
end

if CLIENT then
    local function addPerm(p,r,n)
        if sam then
            sam.permissions.add(p, "Overdone Servers", r)
        end
    end 
    net.Receive("OverdoneServers:Permissions:SendPerms", function()
        if net.ReadBit() == 1 then
            for p,v in pairs(net.ReadTable()) do
                addPerm(p,v,p)
            end
        else
            addPerm(net.ReadString(), net.ReadString(), net.ReadString())                                                                                                                       //pp

        end
    end)
end