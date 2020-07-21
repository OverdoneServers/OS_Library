local PanelMeta = FindMetaTable("Panel")

OverdoneServers.DPanels3D = {}

local function BuildButtonClickAndHoverEvent(but, is3D)
    function but:IsHovered()
        return self.Hovered
    end

    function but:DoClick() end
    function but:DoRightClick() end

    function but:RunMousePress(key)
        if is3D and self:OnMousePressed(key) then return end
        
        if key == MOUSE_LEFT then self:DoClick() end
        if key == MOUSE_RIGHT then self:DoRightClick() end

        --if key == MOUSE_WHEEL_UP then self:DoRightClick() end //TODO: Make this work!
        --if key == MOUSE_WHEEL_DOWN then self:DoRightClick() end
    end

    function but:OnMousePressed(key)
        if not is3D then
            self:RunMousePress(key)
        end
    end

    function but:MousePressed(key)
        if is3D then
            self:RunMousePress(key)
        end  
	end
end

function OverdoneServers.DPanels3D:CreateButton(parent, is3D)
    local but = parent:Add("Panel")
    
    BuildButtonClickAndHoverEvent(but, is3D)

    but.Color = Color(100, 100, 100, 200)
    but.BorderColor = Color(255, 255, 255, 30)

    function but:SetColor(color)
        self.Color = color
    end

    function but:GetColor()
        return self.Color
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
        local colVec = OverdoneServers:ColorToVector(self.Color)
        local hoverCol = OverdoneServers:ColorToVector(OverdoneServers:DarkenColor(self.Color,.5))

        self._curColor = self._curColor or OverdoneServers:ColorToVector(self.Color)

        self.hoverBorder = self.hoverBorder or 0
        self.hoverBorder = Lerp(RealFrameTime() * 5, self.hoverBorder, self:IsHovered() and 255 or self.BorderColor.a)
	            
        if not self._clicking and self:IsHovered() then
            self._curColor = LerpVector(RealFrameTime() * 2, self._curColor, hoverCol)
        elseif self._curColor != colVec then
            self._curColor = LerpVector(RealFrameTime() * 2, self._curColor, self:IsHovered() and hoverCol or colVec)
            if math.abs(self._curColor:DistToSqr(self:IsHovered() and hoverCol or colVec)) < 5 then
                self._curColor = self:IsHovered() and hoverCol or colVec
                self._clicking = false
            end
        end        

        draw.RoundedBox(0,0,0,w,h, Color(0,0,0,100))
        draw.RoundedBox(0,0,0,w,h, OverdoneServers:VectorToColor(self._curColor))

        OverdoneServers.M2D.OutlinedBox(5, 0, 0, w, h, ColorAlpha(self.BorderColor, self.hoverBorder))
    end

    function but:RenderClick()
        self._clicking = true
        self._curColor = OverdoneServers:ColorToVector(OverdoneServers:DarkenColor(self.Color, .75))
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
function PanelMeta:OS_Start3D(position, angle, scale, entity, lockEntPos, lockEntAng, centerPanel)
	if not self:IsValid() then return end

    local x, y = self:GetSize()
    x,y = x*scale, y*scale
    --print(x,y)
    --print((entity and entity:GetAngles():Right()*(x/2) or angle:Right()*(x/2)), (entity and entity:GetAngles():Up()*(y/2) or angle:Up()*(y/2)))
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

    self.OS_3D_PosOffset = Vector(0,0,0)

    self.OS_3D_LockEntPos = (lockEntPos == nil or lockEntPos)
    self.OS_3D_LockEntAng = (lockEntAng == nil or lockEntAng)

    self.OS_3D_CenterPanel = (centerPanel == nil or centerPanel) and true or false

    table.insert(OverdoneServers.DPanels3D, self)
    return true
end
--[[
local function GetAngleOffset(ang, offset)
    return ang:Forward()*offset.x + ang:Right()*offset.y + ang:Up()*offset.z
end
]]

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
        local x,y = p:GetSize()
        x = p.OS_3D_Scale*x or x
        y = p.OS_3D_Scale*y or y
        
        local returnedAng = isfunction(p.OS_3D_Ang) and p.OS_3D_Ang(p, p.OS_3D_Ent) or p.OS_3D_Ang

        local ang = p.OS_3D_Ent and p.OS_3D_Ent:GetAngles() or returnedAng

        ang:RotateAroundAxis(p.OS_3D_Ent:GetAngles():Forward(), returnedAng.x or 0)
        ang:RotateAroundAxis(p.OS_3D_Ent:GetAngles():Right(), returnedAng.y or 0)
        ang:RotateAroundAxis(p.OS_3D_Ent:GetAngles():Up(), returnedAng.z or 0)
        
        local pos = p.OS_3D_PosOffset
            + (p.OS_3D_Ent and (
            p.OS_3D_Ent:GetPos()
                    + p.OS_3D_Pos
                    - (p.OS_3D_CenterPanel and ang:Forward()*(x/2) + ang:Right()*(y/2) or Vector())
                )
                or p.OS_3D_Pos)


        p.OS_3D_LockEntPos = isvector(p.OS_3D_LockEntPos) and p.OS_3D_LockEntPos or (p.OS_3D_LockEntPos == false and pos) or nil
        pos = p.OS_3D_LockEntPos or pos

        p.OS_3D_LockEntAng = isangle(p.OS_3D_LockEntAng) and p.OS_3D_LockEntAng or (p.OS_3D_LockEntAng == false and ang) or nil
        ang = p.OS_3D_LockEntAng or ang

        --render.DrawLine(pos, pos + (ang:Forward() * 30), Color(255, 0, 0))
        --render.DrawLine(pos, pos + (ang:Right() * 30), Color(0, 0, 255))
        --render.DrawLine(pos, pos + (ang:Up() * 30), Color(0, 255, 0))

        --render.DrawLine(p.OS_3D_Ent:GetPos(), p.OS_3D_Ent:GetPos() + (p.OS_3D_Ent:GetAngles():Forward() * 30), Color(255, 0, 0))
        --render.DrawLine(p.OS_3D_Ent:GetPos(), p.OS_3D_Ent:GetPos() + (p.OS_3D_Ent:GetAngles():Right() * 30), Color(0, 0, 255))
        --render.DrawLine(p.OS_3D_Ent:GetPos(), p.OS_3D_Ent:GetPos() + (p.OS_3D_Ent:GetAngles():Up() * 30), Color(0, 255, 0))

        --[[(p.OS_3D_CenterPanel and GetAngleOffset(p.OS_3D_Ent:GetAngles(), centerOffset) or Vector(0,0,0)) + (
            (IsValid(p.OS_3D_Ent) and 
                GetAngleOffset(p.OS_3D_Ent:GetAngles(), Vector((p.OS_3D_Ent:OBBMaxs().x - p.OS_3D_Ent:OBBMins().x) * (p.OS_3D_Pos.x), (p.OS_3D_Ent:OBBMaxs().y - p.OS_3D_Ent:OBBMins().y) * (p.OS_3D_Pos.y), (p.OS_3D_Ent:OBBMaxs().z - p.OS_3D_Ent:OBBMins().z) * (p.OS_3D_Pos.z + .5))) + p.OS_3D_Ent:GetPos() or 
                (p.OS_3D_LockEntPos and 
                    (GetAngleOffset(p.OS_3D_Ent:GetAngles(), p.OS_3D_Pos) + p.OS_3D_Ent:GetPos()) or 
                    (p.OS_3D_Ent:GetPos() + p.OS_3D_Pos)))
            ))
                     
            or (p.OS_3D_CenterPanel and (GetAngleOffset(p.OS_3D_Ang, centerOffset)) or Vector(0,0,0)) + p.OS_3D_Pos,]]

        vgui.Start3D2D(pos, ang, p.OS_3D_Scale or 1)
		p:Paint3D2D()
	    vgui.End3D2D()
    end
    
    for _,pID in ipairs(toRemove) do
        local pan = OverdoneServers.DPanels3D[pID]
        if IsValid(pan) then pan:Remove() end

        table.remove(OverdoneServers.DPanels3D, pID)
    end
end)

function OverdoneServers.DPanels3D:CreateFloatingPanel(bob, bobSpeed, bobAmplitude, keepUpright, followplayer, offset) //ent, pos/posOffset, ang/followplayer, keepUpright, bob (0 off, 100 size of panel), bobSpeed
    bob = bob or 0 //TODO: may need to test if it equals false
    bobSpeed = bobSpeed or 3
    bobAmplitude = bobAmplitude or 5
    keepUpright = keepUpright or false
    followplayer = followplayer and true or false
    offset = offset or math.Rand(1, 1000)

    local panel = vgui.Create("Panel")
    panel.OS_3D_FollowPlayer = followplayer
    BuildButtonClickAndHoverEvent(panel, true)

    function panel:Paint(w,h)
        draw.RoundedBox(0, 0,0,w,h, Color(0,0,255,255))
		draw.SimpleText("helo", "OS:os_texas_holdem:Fancy", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        panel.OS_3D_PosOffset = Vector(0, 0, bobAmplitude * math.sin(bobSpeed * CurTime() + offset))
    end
    return panel
end