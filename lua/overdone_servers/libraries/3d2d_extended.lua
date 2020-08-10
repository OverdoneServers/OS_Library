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

    function but:SetMaterial(material)
        but.sprite:SetMaterial(material)
    end

    function but:GetMaterial()
        return but.sprite:GetMaterial()
    end

    function but:SetRotation(i)
        but.sprite:SetRotation(i)
    end

    function but:GetRotation()
        return but.sprite:GetRotation()
    end

    but._DefSetSize = but._DefSetSize or but.SetSize

    function but:SetSize(x,y)
        if IsValid(but.sprite) then
            local min = math.min(x,y)
            but.sprite:SetSize(min,min)
            but.sprite:SetPos(x/2, y/2)
        end
        self._DefSetSize(self, x,y)
    end

    function but:SetMaterialScale(scale)
        self._MaterialScale = scale
        
        local x,y = self:GetSize()

        local min = math.min(x,y)
        but.sprite:SetSize(min*scale,min*scale)
        but.sprite:SetPos(x/2, y/2)
    end

    function but:GetMaterialScale()
        return self._MaterialScale
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

        OverdoneServers.M2D.OutlinedBox(math.min(but:GetSize())*0.05, 0, 0, w, h, ColorAlpha(self.BorderColor, self.hoverBorder))
    end

    function but:RenderClick()
        self._clicking = true
        self._curColor = OverdoneServers:ColorToVector(OverdoneServers:DarkenColor(self.Color, .75))
    end

    but.sprite = but:Add("DSprite")
    
    but.sprite._DefPaint = but.sprite._DefPaint or but.sprite.Paint

    function but.sprite:Paint(w,h)
        if self.PrePaint then self:PrePaint(w,h) end

        self._DefPaint(self, w,h)
        
        if self.OnPaint then self:OnPaint(w,h) end
        if self.PostPaint then self:PostPaint(w,h) end
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
    childrenList = {}

    if self.ReachDistance != nil then
        ScanForChildren1(self)
        for _,pan in ipairs(childrenList) do
            pan.ReachDistance = pan.ReachDistance or self.ReachDistance
        end
    end
    
    if position != nil and angle != nil and scale != nil then
        self.OS_3D_Pos = position
        self.OS_3D_Ang = isangle(angle) and angle + Angle(0,0,90) or angle
        self.OS_3D_Scale = scale
    else
        if self.OS_3D_Pos == nil or self.OS_3D_Ang == nil or self.OS_3D_Scale == nil then
            ErrorNoHalt("OverdoneServers: Invalid args given for 3D Panel Generation!!!\n")
            return false
        end
    end

    if IsValid(entity) then self.OS_3D_Ent = entity end

    self.OS_3D_PosOffset = Vector(0,0,0)

    self.OS_3D_LockEntPos = (lockEntPos == nil or not lockEntPos)
    self.OS_3D_LockEntAng = (lockEntAng == nil or not lockEntAng)

    self.OS_3D_CenterPanel = (centerPanel == nil or centerPanel) and true or false

    table.insert(OverdoneServers.DPanels3D, self)
    return true
end
--[[
local function GetAngleOffset(ang, offset)
    return ang:Forward()*offset.x + ang:Right()*offset.y + ang:Up()*offset.z
end
]]

local renderOnScreen = false 
hook.Add("Move","OS:TEST", function() 
    if input.WasKeyPressed(KEY_HOME) then
        renderOnScreen = not renderOnScreen
    end
end)

hook.Add("VehicleMove","OS:TEST", function() 
    if input.WasKeyPressed(KEY_HOME) then
        renderOnScreen = not renderOnScreen
    end
end)

hook.Add("PostDrawOpaqueRenderables", "OverdoneServers:Draw3DPanels", function()
    local toRender = {}
    local toRemove = {}
    for i = 1, #OverdoneServers.DPanels3D, 1 do
        local pan = OverdoneServers.DPanels3D[i]
        if not IsValid(pan) or (pan.OS_3D_Ent != nil and not IsValid(pan.OS_3D_Ent)) then
            table.insert(toRemove, i) 
            LocalPlayer():ChatPrint("REMOVED PANEL!! " .. (not IsValid(pan) and "Panel invalid" or "Entity removed"))
        else
            table.insert(toRender, pan)
        end
    end

    local orderedRender = {}
    for _,p in ipairs(toRender) do
        local scale = isfunction(p.OS_3D_Scale) and p.OS_3D_Scale(p) or p.OS_3D_Scale

        local centerOffset = p:OS_3D_CENTER(scale)
        local x,y = p:GetSize()
        x = scale*x or x
        y = scale*y or y
        
        local returnedAng = isfunction(p.OS_3D_Ang) and p.OS_3D_Ang(p, p.OS_3D_Ent) or p.OS_3D_Ang

        local ang = p.OS_3D_Ent and p.OS_3D_Ent:GetAngles() or returnedAng

        ang:RotateAroundAxis((p.OS_3D_Ent and p.OS_3D_Ent:GetAngles() or ang):Forward(), returnedAng.x or 0)
        ang:RotateAroundAxis((p.OS_3D_Ent and p.OS_3D_Ent:GetAngles() or ang):Right(), returnedAng.y or 0)
        ang:RotateAroundAxis((p.OS_3D_Ent and p.OS_3D_Ent:GetAngles() or ang):Up(), returnedAng.z or 0)
        
        local returnedPos = isfunction(p.OS_3D_Pos) and p.OS_3D_Pos(p.OS_3D_Ent) or p.OS_3D_Pos
        local pos = ang:Forward()*p.OS_3D_PosOffset.x + ang:Right()*p.OS_3D_PosOffset.y + ang:Up()*p.OS_3D_PosOffset.z
            + (p.OS_3D_Ent and
                p.OS_3D_Ent:LocalToWorld(returnedPos)
                - (p.OS_3D_CenterPanel and
                    ang:Forward()*(x/2)
                    + ang:Right()*(y/2)
                or Vector())
            or p.OS_3D_Pos)

        pos = (isvector(p.OS_3D_LockEntPos) and
            p.OS_3D_LockEntPos
            - (p.OS_3D_CenterPanel and
                ang:Forward()*(x/2)
                + ang:Right()*(y/2)
            or Vector())
        or pos)
        p.OS_3D_LockEntPos = isvector(p.OS_3D_LockEntPos) and p.OS_3D_LockEntPos or (p.OS_3D_LockEntPos == true and p.OS_3D_PosOffset + (p.OS_3D_Ent and p.OS_3D_Ent:LocalToWorld(p.OS_3D_Pos) or Vector()) or nil)
        //TODO: Why do panels FREAK OUT when placed on world (angle problem)
        p.OS_3D_LockEntAng = isangle(p.OS_3D_LockEntAng) and p.OS_3D_LockEntAng or (p.OS_3D_LockEntAng == true and ang) or nil
        ang = p.OS_3D_LockEntAng or ang

        local playerPos = OverdoneServers.CalcView and OverdoneServers.CalcView.origin or LocalPlayer():EyePos()

        table.insert(orderedRender, playerPos:DistToSqr(pos), {p, pos, ang, scale})
    end

    for _,t in SortedPairs(orderedRender, true) do
        local p,pos,ang,scale = t[1], t[2], t[3], t[4]

        --render.DrawLine(pos, pos + (ang:Forward() * 30), Color(255, 0, 0))
        --render.DrawLine(pos, pos + (ang:Right() * 30), Color(0, 0, 255))
        --render.DrawLine(pos, pos + (ang:Up() * 30), Color(0, 255, 0))

        --render.DrawLine(p.OS_3D_Ent:GetPos(), p.OS_3D_Ent:GetPos() + (p.OS_3D_Ent:GetAngles():Forward() * 30), Color(255, 0, 0))
        --render.DrawLine(p.OS_3D_Ent:GetPos(), p.OS_3D_Ent:GetPos() + (p.OS_3D_Ent:GetAngles():Right() * 30), Color(0, 0, 255))
        --render.DrawLine(p.OS_3D_Ent:GetPos(), p.OS_3D_Ent:GetPos() + (p.OS_3D_Ent:GetAngles():Up() * 30), Color(0, 255, 0))
        --if(p:GetName() == "TableInfoPanel") then print(pos) end

        if not renderOnScreen then
            vgui.Start3D2D(pos, ang, scale or 1)
		        p:Paint3D2D()
	        vgui.End3D2D()
        else
            cam.Start2D()
                p:Paint3D2D()
            cam.End2D()
        end
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

    local panel = vgui.Create("DPanel")
    panel.OS_3D_FollowPlayer = followplayer
    BuildButtonClickAndHoverEvent(panel, true)

    function panel:Paint(w,h)
        panel.OS_3D_PosOffset = Vector(0, bobAmplitude * math.sin(bobSpeed * CurTime() + offset), 0)
        --LocalPlayer():ChatPrint(tostring(panel.OS_3D_PosOffset))
        --draw.RoundedBox(0, 0,0, w,h, Color(150, 75, 75, 50))
        --draw.SimpleText("test", "CloseCaption_Bold", 100, 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        --print(select(1,surface.GetTextSize("WWWWWWWWWWWWWWWWWWWWWWW")))
    end

    --[[timer.Create("FloatingPanel" .. panel, 0, 0, function()
        if not IsValid(panel) then
            timer.Remove("FloatingPanel" .. panel)
        else
            --panel.OS_3D_PosOffset = Vector(0, bobAmplitude * math.sin(bobSpeed * CurTime() + offset), 0)
        end
    end)]]
    return panel
end

local arrowmat = Material("overdone_servers/os_library/panels/hover_panel_arrow.png", "UnlitGeneric")

function OverdoneServers.DPanels3D:CreateInfoPanel(bob, bobSpeed, bobAmplitude, keepUpright, offset, title, info, fontSize, titleFont, infoFont)
    --print(fontSize)
    local panel = self:CreateFloatingPanel(bob, bobSpeed, bobAmplitude, keepUpright, offset)
    --panel:SetSize(width*fontSize*1000,height*fontSize*1000)
    --panel:SetSize(sizex, sizey)
    
    fontSize = fontSize or 4
    infoFont = infoFont or "Default"
    surface.SetFont(infoFont)
    local FontY = select(2, surface.GetTextSize("I"))

    surface.SetFont(titleFont)
    local TitleFontY = select(2, surface.GetTextSize("I"))
    
    function panel:SizeX()
        return select(1, self:GetSize())
    end

    function panel:SizeY()
        return select(2, self:GetSize())
    end

    function panel:returnedinfo()
        return OverdoneServers.BetterText:TextWrap(isfunction(info) and info() or (isstring(info) and info or "Info here"), infoFont, .9*panel:SizeX()/fontSize)
    end 

    function panel:SetBGColor(color)
        self._BGColor = IsColor(color) and color or nil
    end

    function panel:GetBGColor(color)
        return self._BGColor
    end
    function panel:PPPosX()
        return panel:SizeX()/2 - (panel:SizeX()/fontSize)/2
    end
    --PPPosY = 0
    function panel:PPSizeX()
        return panel:SizeX()/fontSize
    end
    function panel:PPSizeY()
        return panel:SizeY()/fontSize
    end

    function panel:SetTitle(text)
        title = text
    end

    function panel:GetTitle()
        return title
    end

    function panel:SetTitleFont(font)
        titleFont = font
    end

    function panel:GetTitle()
        return titleFont
    end

    function panel:SetInfoFont(v)
        info = v
    end

    function panel:GetInfoFont()
        return info
    end

    function panel:SetInfoFont(font)
        infoFont = font
    end

    function panel:GetInfoFont()
        return infoFont
    end

    local top = panel:Add("Panel")
    function top:Paint(w,h)
        self:SetPos(panel:PPPosX(), 0)
        self:SetSize(panel:PPSizeX(), panel:PPSizeY()/2)

        draw.RoundedBox(panel:PPSizeY()/12, 0,0, w,h, panel._BGColor or Color(75, 75, 75, 255))
    end

    local bottom = panel:Add("Panel")
    function bottom:Paint(w,h)
        self:SetPos(panel:PPPosX(), panel:PPSizeY()/2)
        self:SetSize(panel:PPSizeX(), panel:PPSizeY()/2)
    end
    
    local arrow = bottom:Add("DSprite")
    arrow._DefPaint = arrow.Paint
    arrow:SetMaterial(arrowmat)
    function arrow:Paint(w,h)
        self:_DefPaint(w,h)
        self:SetPos(panel:PPSizeX()/2, panel:PPSizeY()/4)
        self:SetSize(panel:PPSizeX()/2, panel:PPSizeY()/2)
        self:SetColor(panel._BGColor or Color(75, 75, 75, 255))
    end
	
	local titlepan = panel:Add("Panel")    
	function titlepan:Paint(w,h)
        local col = Color(25*((255-panel._BGColor.a)/255), 0.1*panel._BGColor.a + 25, 0.1*panel._BGColor.a + 25, panel._BGColor.a) or Color(50, 75, 150, 255)
        draw.RoundedBox(panel:PPSizeY()/12, 0,0, w,h, col)
        draw.RoundedBox(0, 0,h/2, w,h/2, col)
        self:SetPos(panel:PPPosX(), 0)
        self:SetSize(panel:PPSizeX(), panel:PPSizeY()*(1/2)*(1/3))
		draw.SimpleText(title or "Title here", titleFont or "Default", w/2, h/2 + 1.25*TitleFontY/2, Color(255,255,255,panel._BGColor.a) or Color(75, 75, 75, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end
	
	local infopan = panel:Add("Panel")
    local breaks = 0
    timer.Simple(0, function()
        local lastchar = ""
        for _,c in ipairs(string.Explode("", panel.returnedinfo != nil and panel:returnedinfo() or "")) do
            if c == "\n" then
                breaks = breaks + 1
            end
            lastchar = c
        end
    end)

	function infopan:Paint(w,h)
        --draw.RoundedBox(ScrH()*0.04, 0,0, w,h, Color(75, 150, 75, 200))
        self:SetPos(panel:PPPosX(), panel:PPSizeY()*(1/2)*(1/3))
        self:SetSize(panel:PPSizeX(), panel:PPSizeY()*(1/2)*(2/3))
		draw.DrawText(panel:returnedinfo(), infoFont, w/2, h/2 - breaks*FontY*0.61, Color(255,255,255,panel._BGColor.a) or Color(75, 75, 75, 255), TEXT_ALIGN_CENTER)
    end

    return panel
end