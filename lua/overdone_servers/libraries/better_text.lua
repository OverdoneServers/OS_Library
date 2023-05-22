OverdoneServers.BetterText = OverdoneServers.BetterText or {}

if CLIENT then
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

    local entityTable = {}

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
                    DrawText(entityTable[v] or "Invalid Entity")
                elseif v:IsPlayer() then
                    local nick = v:Nick()
                    DrawText(nick)
                    entityTable[v] = nick
                else
                    DrawText(v:GetClass())
                end
            end
        end
        return len
    end
end

function OverdoneServers.BetterText:TableToText(text)
    text = istable(text) and text or {text}

    local out = ""
    for _,v in ipairs(text) do
        if isstring(v) or isnumber(v) or isbool(v) then
            out = out .. tostring(v)
        end
    end
    return out
end

function OverdoneServers.BetterText:AlignString(str, width, alignment, fillChar)
    fillChar = fillChar or " "

    if alignment == TEXT_ALIGN_LEFT then
        return string.format("%-" .. width .. "s", str)
    elseif alignment == TEXT_ALIGN_CENTER then
        local remainingWidth = width - string.len(str)
        local leftPadding = math.floor(remainingWidth / 2)
        local rightPadding = remainingWidth - leftPadding
        return string.rep(fillChar, leftPadding) .. str .. string.rep(fillChar, rightPadding)
    elseif alignment == TEXT_ALIGN_RIGHT then
        return string.format("%" .. width .. "s", str)
    else
        return str
    end
end