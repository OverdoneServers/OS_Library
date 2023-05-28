local Mathf = {} //Allows for some Unity Mathf Functions to work
Mathf.PI = math.pi
function Mathf.Sin(a)
    return math.sin(a)
end
function Mathf.Asin(a)
    return math.asin(a)
end
function Mathf.Pow(a,b)
    return math.pow(a,b)
end
function Mathf.Clamp01(a)
    return math.Clamp(a, 0, 1)
end
function Mathf.Cos(a)
    return math.cos(a)
end
function Mathf.Sqrt(a)
    return math.sqrt(a)
end
function Mathf.Abs(a)
    return math.abs(a)
end

local float = {}
float.Epsilon = 1/math.huge



OverdoneServers.EaseFunctions = {}

local NaturalLogOf2 = 0.693147180559945309417232121458

//
// Easing functions
//

function OverdoneServers.EaseFunctions:Linear(time, from, to)
    return Lerp(time, from, to)
end


function OverdoneServers.EaseFunctions:Spring(time, from, to)
    time = Mathf.Clamp01(time)
    time = (Mathf.Sin(time * Mathf.PI * (0.2 + 2.5 * time * time * time)) * Mathf.Pow(1 - time, 2.2) + time) * (1 + (1.2 * (1 - time)))
    return from + (to - from) * time
end

function OverdoneServers.EaseFunctions:EaseInQuad(time, from, to)
    to = to - from
    return to * time * time + from
end


function OverdoneServers.EaseFunctions:EaseOutQuad(time, from, to)
    to = to - from
    return -to * time * (time - 2) + from
end

function OverdoneServers.EaseFunctions:EaseInOutQuad(time, from, to)
    time = time/.5
    to = to - from
    if (time < 1) then return to * 0.5 * time * time + from end
    time = time - 1
    return -to * 0.5 * (time * (time - 2) - 1) + from
end

function OverdoneServers.EaseFunctions:EaseInCubic(time, from, to)
    to = to - from
    return to * time * time * time + from
end

function OverdoneServers.EaseFunctions:EaseOutCubic(time, from, to)
    time = time - 1
    to = to - from
    return to * (time * time * time + 1) + from
end

function OverdoneServers.EaseFunctions:EaseInOutCubic(time, from, to)
    time = time/.5
    to = to - from
    if (time < 1) then return to * 0.5 * time * time * time + from end
    time = time - 2
    return to * 0.5 * (time * time * time + 2) + from
end

function OverdoneServers.EaseFunctions:EaseInQuart(time, from, to)
    to = to - from
    return to * time * time * time * time + from
end

function OverdoneServers.EaseFunctions:EaseOutQuart(time, from, to)
    time = time - 1
    to = to - from
    return -to * (time * time * time * time - 1) + from
end

function OverdoneServers.EaseFunctions:EaseInOutQuart(time, from, to)
    time = time/.5
    to = to - from
    if (time < 1) then return to * 0.5 * time * time * time * time + from end
    time = time - 2
    return -to * 0.5 * (time * time * time * time - 2) + from
end

function OverdoneServers.EaseFunctions:EaseInQuint(time, from, to)
    to = to - from
    return to * time * time * time * time * time + from
end

function OverdoneServers.EaseFunctions:EaseOutQuint(time, from, to)
    time = time - 1
    to = to - from
    return to * (time * time * time * time * time + 1) + from
end

function OverdoneServers.EaseFunctions:EaseInOutQuint(time, from, to)
    time = time/.5
    to = to - from
    if (time < 1) then return to * 0.5 * time * time * time * time * time + from end
    time = time - 2
    return to * 0.5 * (time * time * time * time * time + 2) + from
end

function OverdoneServers.EaseFunctions:EaseInSine(time, from, to)
    to = to - from
    return -to * Mathf.Cos(time * (Mathf.PI * 0.5)) + to + from
end

function OverdoneServers.EaseFunctions:EaseOutSine(time, from, to)
    to = to - from
    return to * Mathf.Sin(time * (Mathf.PI * 0.5)) + from
end

function OverdoneServers.EaseFunctions:EaseInOutSine(time, from, to)
    to = to - from
    return -to * 0.5 * (Mathf.Cos(Mathf.PI * time) - 1) + from
end

function OverdoneServers.EaseFunctions:EaseInExpo(time, from, to)
    to = to - from
    return to * Mathf.Pow(2, 10 * (time - 1)) + from
end

function OverdoneServers.EaseFunctions:EaseOutExpo(time, from, to)
    to = to - from
    return to * (-Mathf.Pow(2, -10 * time) + 1) + from
end

function OverdoneServers.EaseFunctions:EaseInOutExpo(time, from, to)
    time = time/.5
    to = to - from
    if (time < 1) then return to * 0.5 * Mathf.Pow(2, 10 * (time - 1)) + from end
    time = time - 1
    return to * 0.5 * (-Mathf.Pow(2, -10 * time) + 2) + from
end

function OverdoneServers.EaseFunctions:EaseInCirc(time, from, to)
    to = to - from
    return -to * (Mathf.Sqrt(1 - time * time) - 1) + from
end

function OverdoneServers.EaseFunctions:EaseOutCirc(time, from, to)
    time = time - 1
    to = to - from
    return to * Mathf.Sqrt(1 - time * time) + from
end

function OverdoneServers.EaseFunctions:EaseInOutCirc(time, from, to)
    time = time/.5
    to = to - from
    if (time < 1) then return -to * 0.5 * (Mathf.Sqrt(1 - time * time) - 1) + from end
    time = time - 2
    return to * 0.5 * (Mathf.Sqrt(1 - time * time) + 1) + from
end

function OverdoneServers.EaseFunctions:EaseInBounce(time, from, to)
    to = to - from
    local d = 1
    return to - self:EaseOutBounce(0, to, d - time) + from
end

function OverdoneServers.EaseFunctions:EaseOutBounce(time, from, to)
    --time /= 1f
    to = to - from
    if (time < (1 / 2.75)) then
        return to * (7.5625 * time * time) + from
    end
    if (time < (2 / 2.75)) then
        time = time - (1.5 / 2.75)
        return to * (7.5625 * (time) * time + .75) + from
    end
    if (time < (2.5 / 2.75)) then
        time = time - (2.25 / 2.75)
        return to * (7.5625 * (time) * time + .9375) + from
    end
    time = time - (2.625 / 2.75)
    return to * (7.5625 * (time) * time + .984375) + from
end

function OverdoneServers.EaseFunctions:EaseInOutBounce(time, from, to)
    to = to - from
    local d = 1
    if (time < d * 0.5) then return self:EaseInBounce(0, to, time * 2) * 0.5 + from end
    return self:EaseOutBounce(0, to, time * 2 - d) * 0.5 + to * 0.5 + from
end

function OverdoneServers.EaseFunctions:EaseInBack(time, from, to)
    to = to - from
    --time /= 1
    local s = 1.70158
    return to * (time) * time * ((s + 1) * time - s) + from
end

function OverdoneServers.EaseFunctions:EaseOutBack(time, from, to)
    local s = 1.70158
    to = to - from
    time = time - 1
    return to * ((time) * time * ((s + 1) * time + s) + 1) + from
end

function OverdoneServers.EaseFunctions:EaseInOutBack(time, from, to)
    local s = 1.70158
    to = to - from
    time = time/.5
    if ((time) < 1) then
        s = s * (1.525)
        return to * 0.5 * (time * time * (((s) + 1) * time - s)) + from
    end
    time = time - 2
    s = s * (1.525)
    return to * 0.5 * ((time) * time * (((s) + 1) * time + s) + 2) + from
end

function OverdoneServers.EaseFunctions:EaseInElastic(time, from, to)
    to = to - from

    local d = 1
    local p = d * .3
    local s
    local a = 0

    if (Mathf.Abs(time) < float.Epsilon) then return from end
    //TODO: This may not work -ryan
    time = time / d
    if (Mathf.Abs((time) - 1) < float.Epsilon) then return from + to end

    if (Mathf.Abs(a) < float.Epsilon || a < Mathf.Abs(to)) then
        a = to
        s = p / 4
    else
        s = p / (2 * Mathf.PI) * Mathf.Asin(to / a)
    end
    //TODO: This may not work -ryan
    time = time - 1
    return -(a * Mathf.Pow(2, 10 * (time)) * Mathf.Sin((time * d - s) * (2 * Mathf.PI) / p)) + from
end

function OverdoneServers.EaseFunctions:EaseOutElastic(time, from, to)
    to = to - from

    local d = 1
    local p = d * .3
    local s
    local a = 0

    if (Mathf.Abs(time) < float.Epsilon) then return from end
    //TODO: this may not work - ryan
    time = time/d
    if (Mathf.Abs((time) - 1) < float.Epsilon) then return from + to end

    if (Mathf.Abs(a) < float.Epsilon || a < Mathf.Abs(to)) then
        a = to
        s = p * 0.25
    else
        s = p / (2 * Mathf.PI) * Mathf.Asin(to / a)
    end

    return (a * Mathf.Pow(2, -10 * time) * Mathf.Sin((time * d - s) * (2 * Mathf.PI) / p) + to + from)
end

function OverdoneServers.EaseFunctions:EaseInOutElastic(time, from, to)
    to = to - from

    local d = 1
    local p = d * .3
    local s
    local a = 0

    if (Mathf.Abs(time) < float.Epsilon) then return from end
    time = time / d
    if (Mathf.Abs((time * 0.5) - 2) < float.Epsilon) then return from + to end //TODO: This may not work -Ryan

    if (Mathf.Abs(a) < float.Epsilon || a < Mathf.Abs(to)) then
        a = to
        s = p / 4
    else
        s = p / (2 * Mathf.PI) * Mathf.Asin(to / a)
    end

    if (time < 1) then //TODO: This may not work -Ryan
        time = time - 1
        return -0.5 * (a * Mathf.Pow(2, 10 * (time)) * Mathf.Sin((time * d - s) * (2 * Mathf.PI) / p)) + from
    end
    //TODO: This may not work -Ryan
    time = time - 1
    return a * Mathf.Pow(2, -10 * (time)) * Mathf.Sin((time * d - s) * (2 * Mathf.PI) / p) * 0.5 + to + from
end

function OverdoneServers.EaseFunctions:SmoothDamp(current, target, currentVelocity, smoothTime, maxSpeed, deltaTime)
    local num = 2 / smoothTime
    local num2 = num * deltaTime
    local damp = 1 / (1 + num2 + 0.48 * num2 * num2 + 0.235 * num2 * num2 * num2)
    
    local delta = current - target
    local deltaLength = delta:Length()
    local maxLength = maxSpeed * smoothTime
    
    if deltaLength > maxLength then
        delta = delta * (maxLength / deltaLength)
    end
    
    target = current - delta
    local nextVelocity = (currentVelocity + num * delta) * deltaTime
    currentVelocity = (currentVelocity - num * nextVelocity) * damp
    local next = target + (delta + nextVelocity) * damp
    
    if Vector(target.x - current.x, target.y - current.y, target.z - current.z):Dot(next - target) > 0 then
        next = target
        currentVelocity = (next - target) / deltaTime
    end
    
    return next, currentVelocity
end