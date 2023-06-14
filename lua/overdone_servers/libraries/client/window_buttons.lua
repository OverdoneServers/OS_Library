local WindowButtons = {}
WindowButtons.Preset = {}

local function TilePanelsR2L(offset, pSize, position, mainPanelWidth, initalOffset)
    return mainPanelWidth - pSize*position - offset*position - initalOffset
end

function WindowButtons:Init(parentPanel, ...)
    if not IsValid(parentPanel) then return false end

    local buttonsize = 5 --(% of user's vertical screen size)
    local bordersize = 25 --(% of button size)

    local args = {...}
    local BtS = ScrH()*(buttonsize/100)
    local BrS = BtS*(bordersize/100)
    if #args == 0 then return false end

    local wbPanel = vgui.Create("Panel")
    wbPanel:MakePopup()
    wbPanel:SetSize(BrS + (#args)*(BtS + BrS), BtS + 2*BrS)
    wbPanel:SetPos(ScrW() - BtS - BrS - ((#args)*(BtS + BrS)), BtS)
    --wbPanel:SetMouseInputEnabled(true)
    wbPanel.PosX, wbPanel.PosY = wbPanel:GetPos()
    wbPanel.ScaleX, wbPanel.ScaleY = wbPanel:GetSize()
    function wbPanel:Paint(w,h)
        draw.RoundedBox(30, 0,0,w,h, Color(100,100,255,200))

        if not IsValid(parentPanel) then self:Remove() end
    end

	for i,t in ipairs(args) do
		local name = t[1] --Name to display on hover
		local image = t[2] --Can be material, string location to material, string location to image, Paint Function to call 
		local callback = t[3] -- Must be function(self, wasRightClick)

        local button = wbPanel:Add("Panel")
        button:SetSize(BtS, BtS)
        button:SetPos(TilePanelsR2L(BrS, BtS, i, wbPanel.ScaleX, 0), BrS)
        button:SetMouseInputEnabled(true)
        button:SetCursor("hand")
        button.Callback = callback
        button.DefPaint = button.Paint
        if isfunction(image) then
            button.Paint = image
        elseif isstring(image) then
            button.DisplayImage = Material(image, "UnlitGeneric")
        elseif type(image) == "IMaterial" then
            button.DisplayImage = image
        end

        //TODO: add render hover


        if button.DisplayImage != nil then
            if button.DisplayImage:IsError() then
                function button:Paint(w,h)
                    draw.SimpleText("?", "OverdoneServers:MissingTexture", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            else
                local img = button:Add("DSprite")
                img:SetSize(BtS,BtS)
                img:SetPos(BtS/2, BtS/2)
                img:SetMaterial(button.DisplayImage)
            end
        end
--[[
        function button:Paint(w,h)
            draw.RoundedBox(0, 0,0,w,h, Color(255,0,0,255))
        end
]]

--[[
        function button:Paint(w,h)
            self.HoldingShift = input.IsKeyDown(KEY_LSHIFT)
            if not self.ToPaint then
                --self:DefPaint(w,h)
            else
                self:ToPaint(w,h)
            end
        end]]

        function button:OnMousePressed(key)
            if key == MOUSE_LEFT then
                self.Callback(self, false)
            elseif key == MOUSE_RIGHT then
                self.Callback(self, true)
            end
        end
        
	end

    return true
end

//Give the panel to close when the close button is clicked
function WindowButtons.Preset:Close(panel) --TODO: make it so this can change somehow.
    if not IsValid(panel) then return false end
    return {"Close", 
        function(self, w,h)
            draw.SimpleText("X", "OverdoneServers:MissingTexture", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    ,
        function(self, wasRightClick)
            if not wasRightClick then
                panel:Remove()
            end
        end
    }
end

//Give a function to run when the admin menu button is clicked
function WindowButtons.Preset:AdminMenu(panel, func)
    if not IsValid(panel) then return false end
    return {"AdminMenu", "customizable_notifications/speaker.png",
        function(self, wasRightClick)
            if not wasRightClick then
                LocalPlayer():ChatPrint("Would have opened admin menu")
            end
        end
    }
end

return WindowButtons