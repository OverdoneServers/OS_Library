function OverdoneServers:GetSequentialColor(color)
    local h,s,l = ColorToHSL(color)
    h = h + 1
    if h > 360 then
        h = 0
    end
    local t = HSLToColor(h,s,l)
    return Color(t.r, t.g, t.b, color.a)
end

function OverdoneServers:LightenColor(color, intensity)
    intensity = intensity or .5
    return Color(math.Clamp(color.r + ((255-color.r)*intensity), 0, 255), math.Clamp(color.g + ((255-color.g)*intensity), 0, 255), math.Clamp(color.b + ((255-color.b)*intensity), 0, 255))
end

function OverdoneServers:DarkenColor(color, intensity)
    intensity = intensity or .5
    return Color(math.Clamp(color.r - color.r*intensity, 0, 255), math.Clamp(color.g - color.g*intensity, 0, 255), math.Clamp(color.b - color.b*intensity, 0, 255))
end

function OverdoneServers:ColorToVector(color)
    return Vector(color.r, color.g, color.b)
end

function OverdoneServers:VectorToColor(vector)
    return Color(vector.x, vector.y, vector.z)
end

