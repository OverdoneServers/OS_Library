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

OverdoneServers:LoadFont( 
    {"Text", "rounded-m-plus1c-medium.ttf",
        {
            font = "Rounded Mplus 1c Medium",
            size = 7,
            weight = 500,
        }
    }, "OverdoneServers:ActionBanners:"
)

OverdoneServers.ActionBanners = OverdoneServers.ActionBanners or {}

local ActionBanners = OverdoneServers.ActionBanners

if IsValid(ActionBanners.Panel) then LocalPlayer():ChatPrint("aaaaa") ActionBanners.Panel:Remove() end

ActionBanners.Modules = {
    ["default"] = {
        settings = {
            ["slidespeed"] = 1,
            ["lifetime"] = 60,
            ["width"] = (250/1920),
            ["countdown"] = false, //Uses lifetime - timepassed
            ["default_text_color"] = Color(255,255,255),
            ["background_color"] = Color(75,75,75,150),
            ["max_banners"] = 10,
            ["timer_color"] = Color(200,200,200),
            ["timer_text_color"] = Color(0,0,0),
            ["queue_delay"] = 0.01,
            ["display_by_time"] = false
        }
    }
}

local bannerHeight = nil
local bannerOrigin = nil --middle of your screen, shifted up slightly
local bannerSpacing = nil
local bannerStep = nil
local bannerLimit = nil

local function OnScreenSizeChange()
    bannerHeight = (55/1080)*ScrH()
    bannerOrigin = ScrH()/2 - bannerHeight/2
    bannerSpacing = ScrH()*(24/1080)
    bannerStep = bannerHeight + bannerSpacing
    bannerLimit = math.floor(ScrH()/bannerStep)
end
OnScreenSizeChange() -- Gets Inital Size 

hook.Add("OnScreenSizeChanged", "OverdoneServers:ActionBanners", OnScreenSizeChange)

local function GetNextInLine(module)
    local queue = OverdoneServers.TableHelper:GetValue(ActionBanners.Modules or {}, module, "banner_queue")
    local queueDelay = ActionBanners:GetSetting(module, "queue_delay")
    
    local bannerPanel = nil
    for _, data in ipairs(queue or {}) do
        --print("Comparing", data.waitTime, "and", RealTime() - queueDelay, data.waitTime <= RealTime() - queueDelay)
        if data.waitTime <= RealTime() - queueDelay then
            --print("Okay, greater")
            bannerPanel = data
        end
        if bannerPanel != nil then
            table.remove(queue , 1)
            for _,d in ipairs(queue) do
                d.waitTime = RealTime()
            end
            break
        end
    end
    
    return bannerPanel
end

local GlobalID = 0

local function GetAllBanners(modulee, ignoreHidden)
    local banners = {}
    local bannersLen = 0
    for module ,v in pairs(ActionBanners.Modules or {}) do
        if modulee != nil and modulee != module then continue end
        local display_by_time = ActionBanners:GetSetting(module, "display_by_time")
        local nextToShow = GetNextInLine(module)
        if nextToShow != nil then
            --nextToShow:Show()
            OverdoneServers.TableHelper:InsertValue(nextToShow, ActionBanners.Modules, module, "banners")
            --ActionBanners:UpdateBannerPos()
        end

        if istable(v["banners"]) then
            if ignoreHidden and not ActionBanners:IsVisible(module) then
                for id,panel in pairs(v["banners"]) do
                    if panel:IsVisible() then
                        print("Okay, thats okay")
                        panel:Hide()
                        ActionBanners:UpdateBannerPos()
                    end
                end
            else
                local counter = 0
                for id,panel in pairs(v["banners"]) do
                    if ispanel(panel) and isnumber(panel.init_time) then
                        if display_by_time then
                            counter = counter + 0.000001
                            banners[panel] = RealTime() - panel.init_time + counter
                        else
                            banners[panel] = panel.GlobalID + RealTime()
                        end
                        bannersLen = bannersLen + 1
                        if ignoreHidden != nil and not panel:IsVisible() then
                            panel:Show()
                            ActionBanners:UpdateBannerPos()
                        end
                    end
                end
            end 
        end
    end
    return banners,bannersLen
end

local function BuildActionBannerPanel()
    if IsValid(ActionBanners.Panel) then ActionBanners.Panel:Remove() LocalPlayer():ChatPrint("Removed") end
    
    local panel = vgui.Create("Panel")
    ActionBanners.Panel = panel
    panel:SetSize(ScrW(), ScrH())
    panel:SetPos(0,0)

    function panel:Paint(w,h)
        local toDraw, toDrawLen = GetAllBanners(nil, true)
        local counter = 0
        local modCounter = {}
        for panel, time in SortedPairsByValue(toDraw) do
            counter = counter + 1
            modCounter[panel.module] = (modCounter[panel.module] or 0) + 1
            if counter > bannerLimit then
                if not panel.Removing then
                    --LocalPlayer():ChatPrint("Banner Limit Reached")
                    panel:Remove() //TODO: Should this have a remove animation or just REMOVE IT?
                end
            elseif modCounter[panel.module] > ActionBanners:GetSetting(module, "max_banners") then
                if not panel.Removing then
                    --LocalPlayer():ChatPrint("Max Banners Reached")
                    panel:Remove()
                end
            end

            panel.timepassed = panel.timepassed or 0
            panel.animProgress = panel.animProgress or 0

            if panel.timepassed <= math.pi then
                panel.timepassed = panel.timepassed + RealFrameTime()*3
                panel.animProgress = panel.boostToPos and math.cos((3*math.pi + panel.timepassed)/2) or (math.cos(math.pi + panel.timepassed) + 1)/2
            end

            local ypos = 0
            
            if (toDrawLen % 2 == 0) then //even
                ypos = bannerOrigin + bannerStep*(toDrawLen - (1 + 2*(counter - 1)))/2
            else //odd
                ypos = bannerOrigin + bannerStep*((toDrawLen + 1)/2 - counter)
            end

            panel.animStartPos = panel.animStartPos == nil and (panel.isOld and select(2, panel:GetPos()) or (toDrawLen == 1 and ypos or (ypos + bannerStep + bannerSpacing))) or panel.animStartPos

            panel:SetPos(0, Lerp(panel.animProgress, panel.animStartPos, ypos))
            
            panel.Rendering = true
            panel.isOld = panel.isOld or true
        end
    end

    return panel
end

function ActionBanners:UpdateBannerPos()
    for panel,_ in pairs(GetAllBanners()) do
        if panel.animProgress == nil and 1 or panel.animProgress < 1 then
            panel.boostToPos = true
        end
        panel.timepassed = 0
        panel.animProgress = 0
        panel.animStartPos = nil
    end
end

function ActionBanners:CreateBanner(module, topText, bottomText)
    local panel = vgui.Create("Panel", IsValid(ActionBanners.Panel) and ActionBanners.Panel or BuildActionBannerPanel())
    panel.DefRemove = panel.Remove
    panel.GlobalID = GlobalID

    function panel:Remove()
        if self.Removing then return end
        self._timepassed = 0
        self._animProgress = 0
        self.Removing = true
    end

    panel:SetPos(0,ScrH()-1)
    panel.init_time = RealTime()
    panel:SetSize(1, (55/1080)*ScrH())
    panel.MaxX = ActionBanners:GetSetting(module, "width")*ScrW()

    panel.TopText, panel.BottomText = topText, bottomText
    panel.StartX = 1

    function panel:Paint(w,h)
        if not self.Rendering then return end
        local widthSetting = tonumber(tostring(ActionBanners:GetSetting(module, "width")*ScrW())) //You have to do "to str to num" this cuz some random coding language bug most langs have. (https://codea.io/talk/discussion/8728/0-3-does-not-equal-0-3-codea-bug-lua-bug-ambush-bug)
        if widthSetting != self.MaxX then //Width was changed after panels were created!!!
            self._timepassed = nil
            self.widthChange = true
            self._boostToPos = true
            self._animProgress = nil
            self.StartX = self:GetSize()
            panel.MaxX = widthSetting
        end
    
        if self._timepassed == nil then self:SetSize(1, select(2, self:GetSize())) end

        self._timepassed = self._timepassed or 0
        self._animProgress = self._animProgress or 0
        
        local mathh = (25/1920)*ScrW()

        if self._timepassed <= math.pi then
            self._timepassed = self._timepassed + (RealFrameTime()*4 * (self.FinalRemove and 2 or 1) * ActionBanners:GetSetting(module, "slidespeed"))
            
            self._animProgress = self._boostToPos and math.cos((3*math.pi + self._timepassed)/2) or (math.cos(math.pi + self._timepassed) + 1)/2
            
            if self.Removing then
                if self:GetSize() <= 1 then
                    ActionBanners:UpdateBannerPos()
                    panel.DefRemove(self)
                end
                self:SetSize(OverdoneServers.EaseFunctions:EaseOutExpo(self._animProgress, self.FinalRemove and mathh or self.MaxX, self.FinalRemove and 1 or mathh), select(2, self:GetSize()))
            else
                self:SetSize(OverdoneServers.EaseFunctions:Spring(self._animProgress, self.StartX, self.MaxX), select(2, self:GetSize()))
            end
        elseif self.Removing then
            if not self.FinalRemove then
                self.FinalRemove = true
                self._timepassed = 0
                self._animProgress = 0
            end
        end

        draw.RoundedBox(0,0,0,w,h,ActionBanners:GetSetting(module, "background_color"))
        
        local defaultTextColor = ActionBanners:GetSetting(module, "default_text_color")

        if self.TopText != nil and self.BottomText != nil then
            OverdoneServers.BetterText:DrawText(self.TopText, "OverdoneServers:ActionBanners:Text", mathh*0.1, h*1/3, defaultTextColor)
            OverdoneServers.BetterText:DrawText(self.BottomText, "OverdoneServers:ActionBanners:Text", mathh*0.1, h*2/3, defaultTextColor)
        elseif self.TopText != nil then
            OverdoneServers.BetterText:DrawText(self.TopText, "OverdoneServers:ActionBanners:Text", mathh*0.1, h/2, defaultTextColor)
        elseif self.BottomText != nil then
            OverdoneServers.BetterText:DrawText(self.BottomText, "OverdoneServers:ActionBanners:Text", mathh*0.1, h/2, defaultTextColor)
        end

        draw.RoundedBox(0,w-mathh,0,mathh*1.1,h,ActionBanners:GetSetting(module, "timer_color"))
        local lifetime = ActionBanners:GetSetting(module, "lifetime")
        local num = (RealTime() - self.init_time)

        local endOfLife = num >= lifetime
        num = ActionBanners:GetSetting(module, "countdown") and math.Clamp(lifetime - num, 0, math.huge) or num

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

        local timer_text_color = ActionBanners:GetSetting(module, "timer_text_color")

        draw.SimpleText(str[1], "OverdoneServers:ActionBanners:TimePassed", (w-mathh) + (mathh/2), 0, timer_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(str[2], "OverdoneServers:ActionBanners:TimePassed", (w-mathh) + (mathh/2), h*.3, timer_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(numType, "OverdoneServers:ActionBanners:TimePassed:Small", (w-mathh) + (mathh/2), h*.6, timer_text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        
        if not self.Removing and endOfLife then
            self:Remove()
        end
    end 
    return panel
end

function ActionBanners:Show(module)
    OverdoneServers.TableHelper:SetValue(false, ActionBanners.Modules, module, "hidden")
    return true
end

function ActionBanners:Hide(module)
    OverdoneServers.TableHelper:SetValue(true, ActionBanners.Modules, module, "hidden")
    return true
end

function ActionBanners:IsVisible(module)
    return OverdoneServers.TableHelper:GetValue(ActionBanners.Modules, module, "hidden") != true
end

function ActionBanners:SetSetting(module, name, value)
    OverdoneServers.TableHelper:SetValue(value, ActionBanners.Modules, module, "settings", name)
    return true
end

function ActionBanners:GetSetting(module, name)
    local value = OverdoneServers.TableHelper:GetValue(ActionBanners.Modules, module, "settings", name)

    if value != nil then
        return value, module == "default"
    end

    value = OverdoneServers.TableHelper:GetValue(ActionBanners.Modules, "default", "settings", name)

    if value != nil then
        return value, true
    end
end

function ActionBanners:AddBanner(module, topText, bottomText)
    if module == nil then return nil end
    topText = istable(topText) and topText or {topText}
    bottomText = istable(bottomText) and bottomText or {bottomText}
    
    GlobalID = GlobalID - 1
    local panel = ActionBanners:CreateBanner(module, topText, bottomText)
    panel.module = module
    panel.waitTime = RealTime()
    panel:Hide()

    OverdoneServers.TableHelper:InsertValue(panel, ActionBanners.Modules, module, "banner_queue")
    --Once the panel is created and added to the queue, the queue has its own function that will auto update the client's screen, which will add the next banner and remove the top banner (if max banners are shown)

    --ActionBanners:UpdateBannerPos()

    return GlobalID, panel
end

function ActionBanners:RemoveBanner(module, id)
    --[[local mod = ActionBanners.Modules[module]
    if istable(mod) then
        local banners = mod["banners"]
        if istable(banners) then
            local banner = banners[id]
            if banner != nil then
                if IsValid(banner) then
                    banner:Remove()
                end
                banner = nil
                return true
            end
        end
    end
    return false]]

    
end

function ActionBanners:RemoveAll(module, clearQueue)
    if clearQueue == nil then clearQueue = true end //TODO: make this clear the queue!!!
    for banner,_ in pairs(self:GetBanners(module)) do
        if IsValid(banner) then
            banner:Remove()
        end
    end
    return true
end

function ActionBanners:GetBanners(module)
    return GetAllBanners(module)
end

function ActionBanners:GetBanner(module, id)
    local mod = ActionBanners.Modules[module]
    if istable(mod) then
        local banners = mod["banners"]
        if istable(banners) then
            return banners[id]
        end
    end
    return nil
end

function ActionBanners:SetBanner(module, id, topText, bottomText)
    local panel = self:GetBanner(module, id)
    if IsValid(panel) then
        panel.TopText = topText
        panel.BottomText = bottomText
        return true
    end
    return false
end

ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye")
ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye")
ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye")
ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye")
ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye")
ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye")

timer.Simple(  3+1, function() ActionBanners:AddBanner("test", {LocalPlayer(), Color(255,0,0), " Testing ", Color(0,255,255), "Color!", 1234}, "Aye") end)
timer.Simple(  3+2, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.1, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.2, function() ActionBanners:AddBanner("test", LocalPlayer(), {Color(100,255,150), "Testing"}) end)
timer.Simple(3+2.3, function() 
    local id = ActionBanners:AddBanner("test", {Color(255,100,100), LocalPlayer()}, {Color(100,255,150), "Bet: ", Color(30,200,30), "$1000"})
    timer.Simple(3, function() ActionBanners:RemoveBanner("test", id) end)
end)
timer.Simple(3+2.4, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.5, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.6, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.7, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.8, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+2.9, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+4, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+5, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+6, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+7, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)

timer.Simple(3+12, function() ActionBanners:AddBanner("test", LocalPlayer(), "Testing") end)
timer.Simple(3+5, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+13, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+13.1, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+13.2, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+13.3, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+13.4, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+13.5, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)
timer.Simple(3+14, function() ActionBanners:AddBanner("aa", LocalPlayer(), "aaaaaa") end)

timer.Simple(8, function()
    ActionBanners:SetBanner("test", 3, "Bruh")
end)

timer.Simple(10, function()
    --ActionBanners:RemoveAll()
end)

timer.Simple(1, function()
    ActionBanners:SetSetting("test", "lifetime", 18)
end)
timer.Simple(8, function()
    ActionBanners:SetSetting("test", "width", (500/1920))
    ActionBanners:SetSetting("test", "slidespeed", .5)
    ActionBanners:SetSetting("test", "countdown", true)
end)
timer.Simple(9, function()
    ActionBanners:Hide("test")
end)
timer.Simple(12, function()
    ActionBanners:Show("test")
end)
timer.Simple(12, function()
    ActionBanners:SetSetting("test", "width", (100/1920))
end)

timer.Simple(16, function()
    ActionBanners:SetSetting("test", "width", (1700/1920))
end)
