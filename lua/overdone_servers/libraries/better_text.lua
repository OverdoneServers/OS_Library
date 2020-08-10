OverdoneServers.BetterText = OverdoneServers.BetterText or {}

--Pulled from DarkRP
--[[---------------------------------------------------------------------------
Wrap strings to not become wider than the given amount of pixels
---------------------------------------------------------------------------]]
local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

function OverdoneServers.BetterText:TextWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end

function OverdoneServers.BetterText:DrawText(text, font, w, h, defaultColor, alignX, alignY)
    text = istable(text) and text or {text}
    alignX = alignX or TEXT_ALIGN_LEFT
    alignY = alignY or TEXT_ALIGN_CENTER

    local len = 0
    local lastCol = defaultColor
    
    font = font or "Default"

    surface.SetFont(font)

    local function DrawText(text)
        draw.SimpleText(text, font, w + len, h, lastCol, alignX, alignY)
        len = len + surface.GetTextSize(text)
    end

    for _,v in ipairs(text) do
        if isstring(v) or isnumber(v) or isbool(v) then
            DrawText(tostring(v))
        elseif IsColor(v) then
            lastCol = v
        elseif IsEntity(v) then
            if not IsValid(v) then
                DrawText("Invalid Entity")
            elseif v:IsPlayer() then
                DrawText(v:Nick())
            else
                DrawText(v:GetClass())
            end
        end
    end
end