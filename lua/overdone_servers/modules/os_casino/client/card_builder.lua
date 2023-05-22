local module = OverdoneServers:GetModule("os_casino")
local OS_Casino = module.Data

local function CardKind(kind)
    if kind < 10 then return kind + 1
    elseif kind == 10 then return "J"
    elseif kind == 11 then return "Q"
    elseif kind == 12 then return "K" 
    elseif kind == 13 then return "A"
    else return "Er" end 
end

--Idea: all cards will have an oval with the data inside (what card it is), and the surrounding foreground can be any material you want (card design). This function returns the panel with everything built.
function OS_Casino:BuildCard(cardBackground, cardData, cardForeground, font, suits)
    local genBlankCard = false
    if not isfunction(cardData) then
        PrintTable(istable(cardData) and cardData or {})
        if cardData == nil or cardData == 0 then
            genBlankCard = true
        else
            if not OS_Casino:IsValidCard(cardData) then ErrorNoHalt([[
            ----- OS Casino -----
            Card data is invalid! Card not built.
            ]] ..
            "Suit: " .. (cardData and (tostring(cardData.suit)) or "nil") ..
            "\nKind: " .. (cardData and (tostring(cardData.kind)) or "nil") .. "\n"
            .. [[
            ---------------------
            ]]) return end
        end
    end

    font = font or "Default"
    cardBackground = istable(cardBackground) and cardBackground or {cardBackground}

    local card = vgui.Create("Panel")

    card:SetPos(ScrW()-1, ScrH()-1)

    --function card:Paint(w,h)
    --    draw.RoundedBox(0, 0, 0, w, h, Color(100,255,100))
    --end


    local oval = card:Add("DSprite") --This isn't actually an oval, but it looks like one because of the sprite in front masking it

    local preset = 0

    if IsColor(cardBackground) then
        oval:SetColor(cardBackground)
    elseif istable(cardBackground) and (isnumber(cardBackground[2]) or IsColor(cardBackground[2])) and (cardBackground[3] == nil or isnumber(cardBackground[3])) then
        if (isnumber(cardBackground[2])) then
            oval:SetColor(Color(255,0,0))
            preset = cardBackground[2]
        elseif (isnumber(cardBackground[3])) then
            oval:SetColor(cardBackground[2])
            preset = cardBackground[3]
        end
    else
        ErrorNoHalt("OS:Casino: Card background error.")
    end

    oval:SetMaterial(IsColor(cardBackground) and OverdoneServers.SVG.WhiteSquare or cardBackground[1])

    oval._DefPaint = oval.Paint
    

    local colTime = 0
    local firstCol = oval:GetColor()

    function oval:Paint(w,h)
        colTime = colTime + RealFrameTime()*50
        while colTime > 360 do
            colTime = colTime - 360
        end
        if preset == 1 then
            self:SetColor(OverdoneServers:GetHueColor(firstCol, colTime))
        elseif preset == 2 then
            self:SetColor(Color(firstCol.r + 0.25*firstCol.r*math.sin(math.rad(2*colTime)),firstCol.g + 0.25*firstCol.g*math.sin(math.rad(2*colTime)),firstCol.b + 0.25*firstCol.b*math.sin(math.rad(2*colTime))))
        elseif preset == 3 then
            local c = (Color(firstCol.r + 0.25*firstCol.r*math.sin(math.rad(10*colTime)),firstCol.g + 0.25*firstCol.g*math.sin(math.rad(10*colTime)),firstCol.b + 0.25*firstCol.b*math.sin(math.rad(10*colTime))))
            self:SetColor(OverdoneServers:GetHueColor(c, colTime))
        end

        local cx, cy = card:GetSize()
        self:SetSize(593*cx/968, 593*cy/968)
        self:SetPos(0,0)
        --self:SetPos(cx/2,cy/2)
        self._DefPaint(self,w,h)
    end

    local suitKind = nil
    if isfunction(cardData) or not genBlankCard then 
        local suit,kind = nil,nil
        if isfunction(cardData) then
            local cData = cardData()
            if cData != 0 then
                suit,kind = cData.suit,cData.kind
            end
        else
            suit,kind = cardData.suit,cardData.kind
        end

        suitKind = card:Add("DSprite")

        local matData = suit and suits[suit] or nil

        suitKind:SetMaterial(matData and matData[1] or nil)
        suitKind:SetColor(matData and matData[2] or Color(0,0,0))

        local kindText = kind and CardKind(kind) or ""

        suitKind._DefPaint = suitKind.Paint
        function suitKind:Paint(w,h)
            if isfunction(cardData) then
                local cData = cardData()
                if cData == 0 then
                    suit,kind = nil,nil
                else
                    suit,kind = cData.suit,cData.kind
                end

                local matData = suit and suits[suit] or nil

                suitKind:SetMaterial(matData and matData[1] or nil)
                suitKind:SetColor(matData and matData[2] or Color(0,0,0))

                kindText = kind and CardKind(kind) or ""
            end

            local cx, cy = card:GetSize()
            self:SetSize(3*cx/5, 3*cy/5)
            self:SetPos(0,0)
            --self:SetPos(cx/2,cy/2)

            self._DefPaint(self,w,h)
            draw.SimpleText(kindText, font, 0, 0, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local foreground = card:Add("DSprite")

    foreground:SetMaterial(cardForeground)

    foreground._DefPaint = foreground.Paint
    function foreground:Paint(w,h)
        local cx, cy = card:GetSize()
        self:SetSize(cx, cy)
        --self:SetPos(cx/2,cy/2)
        self:SetPos(0,0)

        self._DefPaint(self,w,h)
    end

    card.background = oval
    card.middle = suitKind
    card.foreground = foreground

    return card
end
