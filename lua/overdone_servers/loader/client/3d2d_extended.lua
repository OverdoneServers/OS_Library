local PanelMeta = FindMetaTable("Panel")

OverdoneServers.DPanels3D = {}

function PanelMeta:OS_3D_CENTER(scale)
	if not self:IsValid() then return end
    local x,y = self:GetSize()
    return Vector(-x*scale/2, -y*scale/2, 0)
end

//If given entity, the pos and ang act as a offset
//[DOES NOT WORK if pos != VectorOffset] If locked, then the panel will work as expected, if false, the offsets will float depending on the entities center
function PanelMeta:OS_Start3D(position, angle, scale, entity, centerPanel, lockEntPos)
	if not self:IsValid() then return end

    if position != nil and angle != nil and scale != nil then
        self.OS_3D_Pos = position
        self.OS_3D_Ang = angle
        self.OS_3D_Scale = scale
    else
        if self.OS_3D_Pos == nil or self.OS_3D_Ang == nil or self.OS_3D_Scale == nil then
            ErrorNoHalt("OverdoneServers: Invalid args given for 3D Panel Generation!!!\n")
            return false
        end
    end

    if IsValid(entity) then self.OS_3D_Ent = entity end
    self.OS_3D_LockEntPos = (lockEntPos == nil or lockEntPos) and true or false
    self.OS_3D_CenterPanel = (centerPanel == nil or centerPanel) and true or false

    table.insert(OverdoneServers.DPanels3D, self)
    return true
end

local function GetAngleOffset(ang, offset)
    return ang:Forward()*offset.x + ang:Right()*offset.y + ang:Up()*offset.z
end

hook.Add("PostDrawOpaqueRenderables", "OverdoneServers:Draw3DPanels", function()
    local toRender = {}
    local toRemove = {}
    for i = 1, #OverdoneServers.DPanels3D, 1 do
        local pan = OverdoneServers.DPanels3D[i]
        if not IsValid(pan) or (pan.OS_3D_Ent != nil and not IsValid(pan.OS_3D_Ent)) then table.insert(toRemove, i)
        else table.insert(toRender, pan) end
    end
    
    for _,p in ipairs(toRender) do
        local centerOffset = p:OS_3D_CENTER(p.OS_3D_Scale)

        vgui.Start3D2D(p.OS_3D_Ent and (
            
            (p.OS_3D_CenterPanel and GetAngleOffset(p.OS_3D_Ent:GetAngles(), centerOffset) or Vector(0,0,0)) + (
            (istable(p.OS_3D_Pos) and 
                GetAngleOffset(p.OS_3D_Ent:GetAngles(), Vector((p.OS_3D_Ent:OBBMaxs().x - p.OS_3D_Ent:OBBMins().x) * (p.OS_3D_Pos[1]), (p.OS_3D_Ent:OBBMaxs().y - p.OS_3D_Ent:OBBMins().y) * (p.OS_3D_Pos[2]), (p.OS_3D_Ent:OBBMaxs().z - p.OS_3D_Ent:OBBMins().z) * (p.OS_3D_Pos[3] + .5))) + p.OS_3D_Ent:GetPos() or 
                (p.OS_3D_LockEntPos and 
                    (GetAngleOffset(p.OS_3D_Ent:GetAngles(), p.OS_3D_Pos) + p.OS_3D_Ent:GetPos()) or 
                    (p.OS_3D_Ent:GetPos() + p.OS_3D_Pos)))))
                     
            or (p.OS_3D_CenterPanel and (GetAngleOffset(p.OS_3D_Ang, centerOffset)) or Vector(0,0,0)) + p.OS_3D_Pos,

            p.OS_3D_Ent and (p.OS_3D_Ent:GetAngles() + p.OS_3D_Ang) or p.OS_3D_Ang,
            p.OS_3D_Scale
        )
		    p:Paint3D2D()
	    vgui.End3D2D()
    end
    
    for _,pID in ipairs(toRemove) do
        local pan = OverdoneServers.DPanels3D[pID]
        if IsValid(pan) then pan:Remove() end

        table.remove(OverdoneServers.DPanels3D, pID)
    end
end)