OverdoneServers.SVG = OverdoneServers.SVG or {}

function OverdoneServers.SVG:LoadSVG(path)

    local svgData = [[
        <svg id="autoscale" width="1699" height="713" viewBox="0 0 1699 713" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="1699" height="713" fill="#3A0000"/>
            <path d="M276.631 373.553H129.256V473.338H302.217V535H52.498V162.469H301.705V224.643H129.256V313.426H276.631V373.553ZM485.156 398.627H424.006V535H347.248V162.469H485.668C529.676 162.469 563.62 172.277 587.5 191.893C611.38 211.508 623.32 239.227 623.32 275.047C623.32 300.462 617.777 321.699 606.689 338.756C595.773 355.643 579.142 369.118 556.797 379.182L637.393 531.418V535H555.006L485.156 398.627ZM424.006 336.453H485.924C505.199 336.453 520.124 331.592 530.699 321.869C541.275 311.976 546.562 298.415 546.562 281.188C546.562 263.618 541.531 249.802 531.467 239.738C521.574 229.674 506.307 224.643 485.668 224.643H424.006V336.453ZM819.82 398.627H758.67V535H681.912V162.469H820.332C864.34 162.469 898.284 172.277 922.164 191.893C946.044 211.508 957.984 239.227 957.984 275.047C957.984 300.462 952.441 321.699 941.354 338.756C930.437 355.643 913.806 369.118 891.461 379.182L972.057 531.418V535H889.67L819.82 398.627ZM758.67 336.453H820.588C839.863 336.453 854.788 331.592 865.363 321.869C875.939 311.976 881.227 298.415 881.227 281.188C881.227 263.618 876.195 249.802 866.131 239.738C856.238 229.674 840.971 224.643 820.332 224.643H758.67V336.453ZM1322.58 357.178C1322.58 393.851 1316.1 426.004 1303.14 453.637C1290.18 481.27 1271.58 502.591 1247.36 517.602C1223.31 532.612 1195.68 540.117 1164.46 540.117C1133.59 540.117 1106.04 532.697 1081.82 517.857C1057.6 503.018 1038.84 481.867 1025.53 454.404C1012.23 426.771 1005.49 395.045 1005.32 359.225V340.803C1005.32 304.13 1011.89 271.891 1025.02 244.088C1038.32 216.114 1057 194.707 1081.05 179.867C1105.27 164.857 1132.91 157.352 1163.95 157.352C1195 157.352 1222.54 164.857 1246.59 179.867C1270.82 194.707 1289.49 216.114 1302.63 244.088C1315.93 271.891 1322.58 304.044 1322.58 340.547V357.178ZM1244.8 340.291C1244.8 301.23 1237.81 271.55 1223.82 251.252C1209.84 230.954 1189.88 220.805 1163.95 220.805C1138.19 220.805 1118.32 230.868 1104.34 250.996C1090.35 270.953 1083.27 300.292 1083.1 339.012V357.178C1083.1 395.215 1090.09 424.725 1104.08 445.705C1118.07 466.686 1138.19 477.176 1164.46 477.176C1190.22 477.176 1210.01 467.112 1223.82 446.984C1237.64 426.686 1244.63 397.177 1244.8 358.457V340.291ZM1516.27 398.627H1455.12V535H1378.36V162.469H1516.78C1560.79 162.469 1594.73 172.277 1618.61 191.893C1642.49 211.508 1654.43 239.227 1654.43 275.047C1654.43 300.462 1648.89 321.699 1637.8 338.756C1626.89 355.643 1610.26 369.118 1587.91 379.182L1668.51 531.418V535H1586.12L1516.27 398.627ZM1455.12 336.453H1517.04C1536.31 336.453 1551.24 331.592 1561.81 321.869C1572.39 311.976 1577.68 298.415 1577.68 281.188C1577.68 263.618 1572.64 249.802 1562.58 239.738C1552.69 229.674 1537.42 224.643 1516.78 224.643H1455.12V336.453Z" fill="#FF1A1A"/>
        </svg>
    ]]

    if string.EndsWith(path, ".svg") then
        path = "download/materials/overdone_servers/" .. path
        if file.Exists(path, "GAME") then
            local fData = file.Read(path, "GAME")
            if fData != "" && fData != " " && fData != "\n" then
                svgData = fData
            end
        end
        svgData = "<svg id=\"autoscale\"" .. string.sub(svgData, 4)
    else
        path = string.Trim(path)
        if string.StartWith(path, "<svg") and string.EndsWith(path, "svg>") then
            svgData = "<svg id=\"autoscale\"" .. string.sub(path, 4)
        end
    end
    
    --[[
    local svgWidth, svgHeight = 0,0
    
    local svgW,svgH = select(3, string.find(select(3, string.find(svgData, "(width..(%d+))")), "(%d+)")), select(3, string.find(select(3, string.find(svgData, "(height..(%d+))")), "(%d+)"))

    svgWidth = svgW == nil and 2^11 or tonumber(svgW)
    svgHeight = svgH == nil and 2^11 or tonumber(svgH)
]]

    local html = vgui.Create("HTML")

    --local pwidth = (svgWidth > svgHeight) and 2^11 or (svgWidth/svgHeight)*2^11
    --local pheight = (svgWidth < svgHeight) and 2^11 or (svgHeight/svgWidth)*2^11


    html:SetSize(2^11,2^11) --2048, the gmod limit! This is set, because the SVG is a function, and it will always be as big as possible!
    html:SetPos(ScrW()-1,ScrH()-1)

    --print("Size: ", html:GetSize())

    html:SetHTML([[
        <html>
            <head>
        		<style>
        			html, body {
        				/* ensure that all of the viewport is used */
        				width: 100%;
        				height: 100%;

        				/* ensure that no scrollbars appear */
        				margin: 0;
        				padding: 0;
                    
        				/* center SVG horizontally and vertically */
        				display: flex;
        				align-items: center;
        				justify-content: center;
        			}
                    #autoscale {
                        /* ensure 1:1 aspect ratio, tweak 50 to make SVG larger */
                        width: 90vmin;
                        height: 90vmin;  

                        /* set some maximum size (width and height need to match
                         * aspect ratio, 1:1 in this case */
                        max-width: 2048px;
                        max-height: 2048px;
                    }
        		</style>
        	</head>
        	<body>
        		<div>  
        			]]
                    .. svgData ..
                    [[
        		</div>
        	</body>
        </html>
    ]])

    return html
end

function OverdoneServers.SVG:RenderSVG(spritePanel)
    if spritePanel._SVG_RenderStart == nil then return end
    if spritePanel._SVG_RenderStart + 1 > RealTime() then
        if IsValid(spritePanel._SVG_HTML_Panel) then
            spritePanel:SetMaterial(spritePanel._SVG_HTML_Panel:GetHTMLMaterial())
        end
    else
        if IsValid(spritePanel._SVG_HTML_Panel) then
            spritePanel._SVG_HTML_Panel:Remove()
            --LocalPlayer():ChatPrint("Cleaned up panel!\n-------------------------")
        else
            --LocalPlayer():ChatPrint("No need to clean up! Panel was already removed.\n-------------------------")
        end
        
        spritePanel._SVG_HTML_Panel = nil
        spritePanel._SVG_RenderStart = nil
    end
end

function OverdoneServers.SVG:SetSVG(spritePanel, path)
    --LocalPlayer():ChatPrint("Loading: " .. path)

    spritePanel._SVG_RenderStart = RealTime()
    spritePanel._SVG_HTML_Panel = self:LoadSVG(path)

    spritePanel._SVG_DefPaint = spritePanel._SVG_DefPaint or spritePanel.Paint

    function spritePanel:Paint(w,h)
        if self.PrePaint then self:PrePaint(w,h) end

        OverdoneServers.SVG:RenderSVG(self)
        self._SVG_DefPaint(self, w,h)
        
        if self.OnPaint then self:OnPaint(w,h) end
        if self.PostPaint then self:PostPaint(w,h) end
    end
end
