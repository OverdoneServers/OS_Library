
OverdoneServers.VisualEffects = {}

local isBlinking = OverdoneServers.VisualEffects.IsBlinking
local eyesClosed = OverdoneServers.VisualEffects.EyesClosed

function OverdoneServers.VisualEffects:BlinkClose(speed)
    speed = speed or 1
    if IsValid(isBlinking) then return end

    local ScrW, ScrH = ScrW(), ScrH()

    isBlinking = vgui.Create("DFrame")
    isBlinking:SetZPos(32766)
    isBlinking:SetSize(ScrW, ScrH)
    isBlinking:SetPos(0, 0)
    function isBlinking:Paint() end


    local top = isBlinking:Add("Panel")
    isBlinking.Top = top
    top:SetSize(ScrW, 1)
    top:SetPos(0, 0)

    function top:GetY()
        local _, py = self:GetSize()
        return py
    end

    function top:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,((self:GetY()) / (ScrH / 2)) * 255))
        self:SetSize(ScrW, Lerp(RealFrameTime() * 2 * speed * (1 + (self:GetY() * 0.008)), self:GetY(), (ScrH / 2) + 100))
        if self:GetY() >= ScrH * 0.55 then eyesClosed = true end
    end

    local bottom = isBlinking:Add("Panel")
    isBlinking.Bottom = bottom
    bottom:SetSize(ScrW, ScrH/2 + 100)
    bottom:SetPos(0, ScrH-1)

    function bottom:GetY()
        local px, py = self:GetPos()
        return py
    end

    function bottom:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,((ScrH-self:GetY())/(ScrH/2))*255))
        self:SetPos(0, Lerp(RealFrameTime()*2*speed*(1+(ScrH - self:GetY())*0.008), self:GetY(), ScrH/2 - 100))
        if self:GetY() <= ScrH*0.45 then eyesClosed = true end
    end
end

function OverdoneServers.VisualEffects:BlinkOpen(speed)
    speed = speed or 1
    if IsValid(isBlinking) then
        local ScrW, ScrH = ScrW(), ScrH()
        function isBlinking.Top:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,((self:GetY())/(ScrH/2))*255))
            self:SetSize(ScrW, Lerp(RealFrameTime()*speed*(1+(ScrH - self:GetY())*0.008), self:GetY(), 0 - 100))
            
            if self:GetY() < 10 then
                isBlinking:Remove()
                isBlinking = nil
            end
        end

        function isBlinking.Bottom:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,((ScrH-self:GetY())/(ScrH/2))*255))
            self:SetPos(0, Lerp(RealFrameTime()*speed*(1+self:GetY()*0.008), self:GetY(), ScrH + 100))
        end
    end
    eyesClosed = false
end

function OverdoneServers.VisualEffects:Blink(speed, func, delay)
    delay = delay or .25
    eyesClosed = false
    OverdoneServers.VisualEffects:BlinkClose(speed)
    local completed = false
    local fail = 5 --(Seconds until eyes are forced open)
    timer.Simple(fail, function()
        if not completed then
            print("Function failed to run function while eyes were closed after " .. fail .. " seconds")
            OverdoneServers.VisualEffects:BlinkOpen(speed)
            timer.Remove("OverdoneServers:VisualEffects:Blink")
        end
    end)
    timer.Create("OverdoneServers:VisualEffects:Blink", 0.01, fail*100, function()
        if eyesClosed then
            func()
            completed = true
            timer.Simple(delay, function() OverdoneServers.VisualEffects:BlinkOpen(speed) end)
            timer.Remove("OverdoneServers:VisualEffects:Blink")
        end
    end)
end

function OverdoneServers.VisualEffects:Crosshair(size)
    local panel = vgui.Create("Panel")
    panel:SetSize(ScrW(),ScrH())
    panel:SetPos(0,0)

    function panel:Paint(w,h)
        draw.RoundedBox(ScrH()*0.001*size/2, ScrW()/2 - ScrH()*0.001*size/2, ScrH()/2 - ScrH()*0.001*size/2, ScrH()*0.001*size, ScrH()*0.001*size, Color(255,255,255,255))
    end
    return panel
end

function OverdoneServers.VisualEffects:Poof(pos, size)
    --[[local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	effectdata:SetScale(size)
    for i = 0, 10 do]]
		ParticleEffect("generic_smoke", pos, Angle(0,0,0))
    --end
end

net.Receive("OverdoneServers:VisualEffects:Poof", function()
    pos = net.ReadVector()
    size = net.ReadInt(12)
    OverdoneServers.VisualEffects:Poof(pos, size)
end)

--PrintTable(list.Get("EffectType"))