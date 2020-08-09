OverdoneServers:LoadFont( 
    {"TimePassed", "rounded-m-plus1c-extrabold.ttf",
        {
            font = "Rounded Mplus 1c ExtraBold",
            size = 8,
            weight = 500,
        }
    }, "OverdoneServers:ActionBanners:"
)

OverdoneServers:LoadFont( 
    {"TimePassed:Small", "rounded-m-plus1c-medium.ttf",
        {
            font = "Rounded Mplus 1c Medium",
            size = 7,
            weight = 500,
        }
    }, "OverdoneServers:ActionBanners:"
)



OverdoneServers.ActionBanners = OverdoneServers.ActionBanners or {}
if IsValid(ActionBanners.Panel) then ActionBanners.Panel:Remove() end
OverdoneServers.ActionBanners = {}

ActionBanners = OverdoneServers.ActionBanners
ActionBanners.Modules = {}

if CLIENT then
    if IsValid(ActionBanners.Panel) then ActionBanners.Panel:Remove() end //TODO: Remove this. Just here for testing

    local bannerHeight = (55/1080)*ScrH()

    local function GetAllBanners()
        local banners = {}
        local bannersLen = 0
        for module ,v in pairs(ActionBanners.Modules or {}) do
            if istable(v["banners"]) and not table.IsEmpty(v["banners"]) then
                for id,panel in pairs(v["banners"]) do
                    if ispanel(panel) and isnumber(panel.init_time) then
                        banners[panel] = RealTime() - panel.init_time
                        bannersLen = bannersLen + 1
                    end
                end
            end
        end
        return banners,bannersLen
    end

    local function BuildActionBannerPanel()
        if IsValid(ActionBanners.Panel) then ActionBanners.Panel:Remove() end
        
        local panel = vgui.Create("Panel")
        ActionBanners.Panel = panel
        panel:SetSize(ScrW(), ScrH())
        panel:SetPos(0,0)

        function panel:Paint(w,h)
            
            local toDraw, toDrawLen = GetAllBanners()

            local counter = 0
            for panel, time in SortedPairsByValue(toDraw) do
                counter = counter + 1

                panel.timepassed = panel.timepassed or 0
                panel.animProgress = panel.animProgress or 0

                if panel.timepassed <= math.pi then
                    panel.timepassed = panel.timepassed + RealFrameTime()*3
                    panel.animProgress = panel.boostToPos and math.cos((3*math.pi + panel.timepassed)/2) or (math.cos(math.pi + panel.timepassed) + 1)/2
                end

                local ypos = 0
                local panelheight = bannerHeight --panelheight
                local origin = ScrH()/2 - panelheight/2 --middle of your screen, shifted up slightly
                local spacing = ScrH()*(24/1080)
                local step = panelheight + spacing
                
                if (toDrawLen % 2 == 0) then
                    ypos = origin + step*(toDrawLen - (1 + 2*(counter - 1)))/2
                    --print("theoretically even")
                else
                    ypos = origin + step*((toDrawLen + 1)/2 - counter)
                    --print("theoretically odd")
                end
                
                --[[if panel.animStartPos == nil then
                    if panel.isOld then
                        panel.animStartPos = select(2, panel:GetPos())
                    else
                        panel.animStartPos = (ypos + step + spacing)
                    end
                else
                    panel.animStartPos = panel.animStartPos
                end]]

                panel.animStartPos = panel.animStartPos == nil and (panel.isOld and select(2, panel:GetPos()) or (toDrawLen == 1 and ypos or (ypos + step + spacing))) or panel.animStartPos

                panel:SetPos(0, Lerp(panel.animProgress, panel.animStartPos, ypos))
                
                panel.isOld = panel.isOld or true
            end
        end

        return panel
    end

    BuildActionBannerPanel() //Build initial panel. TODO: Should we not even do this until a banner is added?

    local function CreateBanner(textData)
        for panel,_ in pairs(GetAllBanners()) do
            if panel.animProgress == nil and 1 or panel.animProgress < 1 then
                panel.boostToPos = true
            end
            panel.timepassed = 0
            panel.animProgress = 0
            panel.animStartPos = nil
        end

        local panel = vgui.Create("Panel", IsValid(ActionBanners.Panel) and ActionBanners.Panel or BuildActionBannerPanel())
        panel:SetPos(0,ScrH()-1)
        panel.init_time = RealTime()
        panel:SetSize((250/1920)*ScrW(), (55/1080)*ScrH())
        --panel:SetPos(0,ScrH()/2)

        //if topText == nil then TODO: Center text vertically. Horizontal should be left for any case        

        panel.MaxX = panel:GetSize()

        function panel:Paint(w,h)
            if panel._timepassed == nil then panel:SetSize(1, select(2, panel:GetSize())) end

            panel._timepassed = panel._timepassed or 0
            panel._animProgress = panel._animProgress or 0

            if panel._timepassed <= math.pi then
                panel._timepassed = panel._timepassed + RealFrameTime()*4
                panel._animProgress = (math.cos(math.pi + panel._timepassed) + 1)/2
                panel:SetSize(OverdoneServers.EaseFunctions:Spring(panel._animProgress, 1, panel.MaxX), select(2, panel:GetSize()))
            end

            draw.RoundedBox(0,0,0,w,h,Color(100,0,0,150))

            local mathh = (25/1920)*ScrW()
            draw.RoundedBox(0,w-mathh,0,mathh*1.1,h,Color(200,200,200,255))
            
            local num = RealTime() - panel.init_time

            local numType = ""
            if num < 60 then
                num = math.floor(num)
                numType = "s" //Seconds
            elseif num < 60*60 then
                num = math.floor(num/60)
                numType = "m" //Minutes
            elseif num < 60*60*24 then
                num = math.floor(num/60/60)
                numType = "h" //Hours
            elseif num < 60*60*24*7 then
                num = math.floor(num/60/60/24)
                numType = "d" //Days
            elseif num < 60*60*24*7*52.1429 then
                num = math.floor(num/60/60/24/7)
                numType = "w" //Weeks
            elseif num < 60*60*24*7*52.1429*10 then
                num = math.floor(num/60/60/24/7/52.1429)
                numType = "y" //Years
            elseif num < 60*60*24*7*52.1429*10*10 then
                num = math.floor(num/60/60/24/7/52.1429/10)
                numType = "D" //Decades ( ͡° ͜ʖ ͡°)
            elseif num < 60*60*24*7*52.1429*10*10*10 then
                num = math.floor(num/60/60/24/7/52.1429/10/10)
                numType = "C" //Centuries ( ͡° ͜ʖ ͡°)
            elseif num < 60*60*24*7*52.1429*10*10*10*1000 then
                num = math.floor(num/60/60/24/7/52.1429/10/10/10)
                numType = "M" //Millenia ( ͡° ͜ʖ ͡°)
            elseif num < 60*60*24*7*52.1429*10*10*10*1000*10 then
                num = math.floor(num/60/60/24/7/52.1429/10/10/10/1000)
                numType = "A" //Ages ( ͡° ͜ʖ ͡°)
            elseif num < 60*60*24*7*52.1429*10*10*10*1000*10*10 then
                num = math.floor(num/60/60/24/7/52.1429/10/10/10/1000/10)
                numType = "Ep" //Epochs ( ͡° ͜ʖ ͡°)
            elseif num < 60*60*24*7*52.1429*10*10*10*1000*10*10*10 then
                num = math.floor(num/60/60/24/7/52.1429/10/10/10/1000/10/10)
                numType = "Er" //Eras ( ͡° ͜ʖ ͡°)
            else
                num = math.floor(num/60/60/24/7/52.1429/10/10/10/1000/10/10/10)
                numType = "Eo" //Eons ( ͡° ͜ʖ ͡°)
            end

            local str = string.Split(string.format("%02d", tostring(num)), "")

            draw.SimpleText(str[1], "OverdoneServers:ActionBanners:TimePassed", (w-mathh) + (mathh/2), 0, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(str[2], "OverdoneServers:ActionBanners:TimePassed", (w-mathh) + (mathh/2), h*.3, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText(numType, "OverdoneServers:ActionBanners:TimePassed:Small", (w-mathh) + (mathh/2), h*.6, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end 
        return panel
    end

    function ActionBanners:Show(module)
        return //success bool
    end

    function ActionBanners:Hide(module)
        return //success bool
    end

    function ActionBanners:IsVisible(module)
        return //bool
    end

//if setting isnt specified, use default
    --[=[ActionBanners.Modules = {
        module1 = {
            settings = {
                "lifetime" = 45
            },
            banners = {

            }
        },
        module2 = {
            settings = {

            },
            banners = {

            }
        },
        ["default"] = {
            settings = {
                slidetime = 0.3,
                "lifetime" = 60
            }
        }
    }]=]

    function ActionBanners:SetSetting(module, name, value)

        return //success bool
    end

    function ActionBanners:GetSetting(module, name)

        return //value, if value was default (bool)
    end

    function ActionBanners:IsSettingSet(module, name)

        return //bool
    end

    --ActionBanners:AddBanner(module, ply, Color(255,0,0), "Bet ", Color(0,200,0), "$", Color(0,0,255), "1000")

    function ActionBanners:AddBanner(module, topText, ...)
        //TODO: remove the last banner if greater than the max amount

        local args = {...}
        topText = (isentity(topText) and topText:IsPlayer()) and topText:Nick() or topText

        ActionBanners.Modules[module] = ActionBanners.Modules[module] or {}
        ActionBanners.Modules[module]["banners"] = ActionBanners.Modules[module]["banners"] or {}

        local textData = {}
        textData["top-text"] = topText
        textData["bottom-text"] = args

        local panel = CreateBanner(textData)
        
        local id = table.insert(ActionBanners.Modules[module]["banners"], panel)

        return id, panel
    end

    timer.Simple(1, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.1, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.2, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.3, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.4, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.5, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.6, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.7, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.8, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)
    timer.Simple(2.9, function() ActionBanners:AddBanner("test", LocalPlayer(), "Pp moment") end)

    function ActionBanners:RemoveBanner(module, id)
        return //success bool
    end
    
    function ActionBanners:RemoveAll(module)
        if module == nil then //TODO: REMOVE ALL / for loop
        end
        return //success bool
    end

    function ActionBanners:GetBanners(module)
        if module == nil then //TODO: Return all banners for all modules / for loop
        end
        return //table of bannerids for that localplayer
    end

    function ActionBanners:GetBanner(module, id) --needed?
    end

    function ActionBanners:SetBanner(module, id, ...)
        return //success bool
    end
    
end