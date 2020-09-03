OverdoneServers.DPanels2D = {}

function OverdoneServers.DPanels2D:CloseButton(panel, manualPos) // panel to put close button on. bool if YOU have to set the position manually
    local closeOffset = 45
    local closeButtonColors = {Color(190, 100, 10, 255), Color(255, 50, 40, 255)}
    local closeButtonColor = closeButtonColors[1]
    local closeButtonPartA
    local closeButtonPartB
    local circle

    local closeButton = panel:Add("DButton")
    closeButton:SetText("")

    closeButton.DefSetSize = closeButton.SetSize
    function closeButton:SetSize(size)
        closeButton:DefSetSize(size, size)
    end
    
    closeButton._Scale = 0.9
    function closeButton:SetScale(amount)
        closeButton._Scale = amount
    end

    function closeButton:TestHover(x, y)
		local x, y = self:ScreenToLocal(x, y) -- Convert to local coordinates
		local dist = math.sqrt((x-self:GetWide()/2)^2 + (y-self:GetTall()/2)^2) -- Simple distance calculation
		return dist < math.min(self:GetWide(), self:GetTall())/2 -- Return true if the cursor is within the buttons circular radius
	end

    function closeButton:Paint(w,h)
        self.SizeX,self.SizeY = self:GetSize()
        local pSizeX, pSizeY = panel:GetSize()
        if not manualPos then self:SetPos(pSizeX-self.SizeX*1.2, self.SizeY*0.2) end
        if self:IsHovered() then
            if closeOffset < 90 then
                closeOffset = math.Clamp(closeOffset + RealFrameTime() * 250, 0, 135)
                closeButtonColor = closeButtonColors[1]
            elseif closeOffset < 135 then
                closeOffset = math.Clamp(closeOffset + RealFrameTime() * 250, 0, 135)
                closeButtonColor = closeButtonColors[2]
            end
        else
            if closeOffset > 90 then
                closeOffset = math.Clamp(closeOffset - RealFrameTime() * 250, 0, 135)
                closeButtonColor = closeButtonColors[2]
            elseif closeOffset > 45 then
                closeOffset = math.Clamp(closeOffset - RealFrameTime() * 250, 0, 135)
                closeButtonColor = closeButtonColors[1]
            end
        end
        circle:SetSize(self.SizeX,self.SizeY)
        circle:SetPos(self.SizeX/2,self.SizeY/2)
    end

    function closeButton:DoClick()
        if panel.Close then panel:Close() else panel:Remove() end
    end

    circle = closeButton:Add("DSprite")
    circle:SetMaterial(OverdoneServers.Materials["Circle"])
    circle:SetColor(Color(30,30,30,200))

    closeButtonPartA = closeButton:Add("DSprite")
    closeButtonPartA:SetMaterial(OverdoneServers.Materials["RoundedBar"])
    closeButtonPartA.defaultFunc = closeButtonPartA.Paint
    function closeButtonPartA:Paint(s,w,h)
        self:SetSize(closeButton.SizeX*closeButton._Scale,closeButton.SizeY*closeButton._Scale)
        self:SetPos(closeButton.SizeX/2,closeButton.SizeY/2)
        self:SetRotation(-closeOffset)
        self:SetColor(closeButtonColor)
        closeButtonPartA:defaultFunc(s,w,h)
    end

    closeButtonPartB = closeButton:Add("DSprite")
    closeButtonPartB:SetMaterial(OverdoneServers.Materials["RoundedBar"])
    closeButtonPartB:SetColor(Color(190, 100, 10, 255))
    closeButtonPartB.defaultFunc = closeButtonPartB.Paint
    function closeButtonPartB:Paint(s,w,h)
        self:SetSize(closeButton.SizeX*closeButton._Scale,closeButton.SizeY*closeButton._Scale)
        self:SetPos(closeButton.SizeX/2,closeButton.SizeY/2)
        self:SetRotation(closeOffset)
        self:SetColor(closeButtonColor)
        closeButtonPartB:defaultFunc(s,w,h)
    end

    closeButton.closeButtonPartA = closeButtonPartA
    closeButton.closeButtonPartB = closeButtonPartB
    closeButton.circle = circle

    return closeButton
end