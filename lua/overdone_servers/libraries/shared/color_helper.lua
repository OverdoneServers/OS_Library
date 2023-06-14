local Colors = {}

function Colors:GetSequentialColor(color)
    local h,s,l = ColorToHSL(color)
    h = h + 1
    if h > 360 then
        h = 0
    end
    local t = HSLToColor(h,s,l)
    return Color(t.r, t.g, t.b, color.a)
end

function Colors:GetColorOffset(color, offset)
    local h,s,l = ColorToHSL(color)
    h = h + offset
    while h > 360 do
        h = h - 360
    end
    local t = HSLToColor(h,s,l)
    return Color(t.r, t.g, t.b, color.a)
end

function Colors:GetHueColor(color, hue)
    local h,s,l = ColorToHSL(color)
    h = h + hue
    while h > 360 do
        h = h - 360
    end
    local t = HSLToColor(h,s,l)
    return Color(t.r, t.g, t.b, color.a)
end

function Colors:GetColorFromHue(hue)
    while hue > 360 do
        hue = hue - 360
    end
    local t = HSLToColor(hue,1,0.5)
    return Color(t.r, t.g, t.b, 255)
end

function Colors:GetLightnessColor(color, lightness)
    local h,s,l = ColorToHSL(color)
    l = l + lightness
    local t = HSLToColor(h,s,l)
    return Color(t.r, t.g, t.b, color.a)
end

function Colors:LightenColor(color, intensity)
    intensity = intensity or .5
    return Color(math.Clamp(color.r + ((255-color.r)*intensity), 0, 255), math.Clamp(color.g + ((255-color.g)*intensity), 0, 255), math.Clamp(color.b + ((255-color.b)*intensity), 0, 255))
end

function Colors:DarkenColor(color, intensity)
    intensity = intensity or .5
    return Color(math.Clamp(color.r - color.r*intensity, 0, 255), math.Clamp(color.g - color.g*intensity, 0, 255), math.Clamp(color.b - color.b*intensity, 0, 255))
end

function Colors:ColorToVector(color)
    return Vector(color.r, color.g, color.b)
end

function Colors:VectorToColor(vector)
    return Color(vector.x, vector.y, vector.z)
end

return Colors