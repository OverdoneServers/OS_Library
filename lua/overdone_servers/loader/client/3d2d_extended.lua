local PanelMeta = FindMetaTable("Panel")

OverdoneServers.DPanels3D = {}

function OverdoneServers.DPanels3D:CreateButton(parent)
    local but = parent:Add("Panel")
    function but:IsHovered()
        return self.Hovered
    end

    function but:OnMousePressed(key) end
    function but:DoClick() end
    function but:DoRightClick() end

    function but:MousePressed(key)
		if self:OnMousePressed(key) then return end
    	if key == MOUSE_LEFT then self:DoClick() end
    	if key == MOUSE_RIGHT then self:DoRightClick() end

    	--if key == MOUSE_WHEEL_UP then self:DoRightClick() end //TODO: Make this work!
    	--if key == MOUSE_WHEEL_DOWN then self:DoRightClick() end
	end

    but.Color = Color(100, 100, 100, 200)
    but.TextColor = Color(255, 255, 255, 255)
    but.BorderColor = Color(200, 200, 200, 50)

    function but:SetColor(color)
        self.Color = color
    end

    function but:GetColor()
        return self.Color
    end

    function but:SetTextColor(color)
        self.TextColor = color
    end

    function but:GetTextColor()
        return self.TextColor
    end

    function but:SetBorderColor(color)
        self.BorderColor = color
    end

    function but:GetBorderColor()
        return self.BorderColor
    end

    but.ClickAnimationMultiplier = 2

    local clickAnimationTimeMax = 2
    local clickAnimationTime = 0

    function but:RenderHover()
        local w,h = self:GetSize()
        self.hoverColor = self.hoverColor or 0
	    self.hoverColor = Lerp(RealFrameTime() * 5, self.hoverColor, self:IsHovered() and 120 or 0)
	    
        self.hoverBorder = self.hoverBorder or 0
        self.hoverBorder = Lerp(RealFrameTime() * 5, self.hoverBorder, self:IsHovered() and 255 or self.BorderColor.a)
	    
        self.clickColor = self.clickColor or OverdoneServers:ColorToVector(self.Color)
        local colVec = OverdoneServers:ColorToVector(self.Color)
        print(type(colVec), type(self.clickColor))
        if self.clickColor != colVec then
            self.clickColor = LerpVector(RealFrameTime() * 2, self.clickColor, colVec)
        end

        if math.abs(self.clickColor:DistToSqr(colVec)) < 10 then
            self.clickColor = colVec
        end

        draw.RoundedBox(0,0,0,w,h, Color(0,0,0,100))
        draw.RoundedBox(0,0,0,w,h, OverdoneServers:VectorToColor(self.clickColor))

        OverdoneServers.M2D.OutlinedBox(5, 0, 0, w, h, ColorAlpha(self.BorderColor, self.hoverBorder))
    end

    return but
end

function PanelMeta:OS_3D_CENTER(scale)
	if not self:IsValid() then return end
    local x,y = self:GetSize()
    return Vector(-x*scale/2, -y*scale/2, 0)
end

local ScanForChildren2 = nil

local childrenList = {}

local ScanForChildren1 = function(pnl)
    for _,v in ipairs(pnl:GetChildren()) do
        table.insert(childrenList, v)
        ScanForChildren2(v)
    end
end

ScanForChildren2 = function(pnl)
    for _,v in ipairs(pnl:GetChildren()) do
        table.insert(childrenList, v)
        ScanForChildren1(v)
    end
end

//If given entity, the pos and ang act as a offset
//[DOES NOT WORK if pos != VectorOffset] If locked, then the panel will work as expected, if false, the offsets will float depending on the entities center
function PanelMeta:OS_Start3D(position, angle, scale, entity, centerPanel, lockEntPos)
	if not self:IsValid() then return end

    childrenList = {}

    if self.ReachDistance != nil then
        ScanForChildren1(self)
        for _,pan in ipairs(childrenList) do
            pan.ReachDistance = pan.ReachDistance or self.ReachDistance
        end
    end

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