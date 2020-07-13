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




/*
//
// These are derived functions that the motor can use to get the speed at a specific time.
//
// The easing functions all work with a normalized time (0 to 1) and the returned time here
// reflects that. Values returned here should be divided by the actual time.
//
// TODO: These functions have not had the testing they deserve. If there is odd behavior around
//       dash speeds then this would be the first place I'd look.

function OverdoneServers.EaseFunctions:LinearD(time, from, to)
{
    return to - from;
}

function OverdoneServers.EaseFunctions:EaseInQuadD(time, from, to)
{
    return 2f * (to - from) * time;
}

function OverdoneServers.EaseFunctions:EaseOutQuadD(time, from, to)
{
    to = to - from;
    return -to * time - to * (time - 2);
}

function OverdoneServers.EaseFunctions:EaseInOutQuadD(time, from, to)
{
    time = time/.5
    to = to - from;

    if (time < 1)
    {
        return to * time;
    }

    time = time - 1

    return to * (1 - time);
}

function OverdoneServers.EaseFunctions:EaseInCubicD(time, from, to)
{
    return 3f * (to - from) * time * time;
}

function OverdoneServers.EaseFunctions:EaseOutCubicD(time, from, to)
{
    time = time - 1
    to = to - from;
    return 3f * to * time * time;
}

function OverdoneServers.EaseFunctions:EaseInOutCubicD(time, from, to)
{
    time = time/.5
    to = to - from;

    if (time < 1)
    {
        return (3f / 2f) * to * time * time;
    }

    time -= 2;

    return (3f / 2f) * to * time * time;
}

function OverdoneServers.EaseFunctions:EaseInQuartD(time, from, to)
{
    return 4f * (to - from) * time * time * time;
}

function OverdoneServers.EaseFunctions:EaseOutQuartD(time, from, to)
{
    time = time - 1
    to = to - from;
    return -4f * to * time * time * time;
}

function OverdoneServers.EaseFunctions:EaseInOutQuartD(time, from, to)
{
    time = time/.5
    to = to - from;

    if (time < 1)
    {
        return 2f * to * time * time * time;
    }

    time -= 2;

    return -2f * to * time * time * time;
}

function OverdoneServers.EaseFunctions:EaseInQuintD(time, from, to)
{
    return 5f * (to - from) * time * time * time * time;
}

function OverdoneServers.EaseFunctions:EaseOutQuintD(time, from, to)
{
    time = time - 1
    to = to - from;
    return 5f * to * time * time * time * time;
}

function OverdoneServers.EaseFunctions:EaseInOutQuintD(time, from, to)
{
    time = time/.5
    to = to - from;

    if (time < 1)
    {
        return (5f / 2f) * to * time * time * time * time;
    }

    time -= 2;

    return (5f / 2f) * to * time * time * time * time;
}

function OverdoneServers.EaseFunctions:EaseInSineD(time, from, to)
{
    return (to - from) * 0.5f * Mathf.PI * Mathf.Sin(0.5f * Mathf.PI * time);
}

function OverdoneServers.EaseFunctions:EaseOutSineD(time, from, to)
{
    to = to - from;
    return (Mathf.PI * 0.5f) * to * Mathf.Cos(time * (Mathf.PI * 0.5f));
}

function OverdoneServers.EaseFunctions:EaseInOutSineD(time, from, to)
{
    to = to - from;
    return to * 0.5f * Mathf.PI * Mathf.Sin(Mathf.PI * time);
}

function OverdoneServers.EaseFunctions:EaseInExpoD(time, from, to)
{
    return 10f * NaturalLogOf2 * (to - from) * Mathf.Pow(2f, 10f * (time - 1));
}

function OverdoneServers.EaseFunctions:EaseOutExpoD(time, from, to)
{
    to = to - from;
    return 5f * NaturalLogOf2 * to * Mathf.Pow(2f, 1f - 10f * time);
}

function OverdoneServers.EaseFunctions:EaseInOutExpoD(time, from, to)
{
    time = time/.5
    to = to - from;

    if (time < 1)
    {
        return 5f * NaturalLogOf2 * to * Mathf.Pow(2f, 10f * (time - 1));
    }

    time = time - 1

    return (5f * NaturalLogOf2 * to) / (Mathf.Pow(2f, 10f * time));
}

function OverdoneServers.EaseFunctions:EaseInCircD(time, from, to)
{
    return (to - from) * time / Mathf.Sqrt(1f - time * time);
}

function OverdoneServers.EaseFunctions:EaseOutCircD(time, from, to)
{
    time = time - 1
    to = to - from;
    return (-to * time) / Mathf.Sqrt(1f - time * time);
}

function OverdoneServers.EaseFunctions:EaseInOutCircD(time, from, to)
{
    time = time/.5
    to = to - from;

    if (time < 1)
    {
        return (to * time) / (2f * Mathf.Sqrt(1f - time * time));
    }

    time -= 2;

    return (-to * time) / (2f * Mathf.Sqrt(1f - time * time));
}

function OverdoneServers.EaseFunctions:EaseInBounceD(time, from, to)
{
    to = to - from;
    local d = 1;

    return EaseOutBounceD(0, to, d - time);
}

function OverdoneServers.EaseFunctions:EaseOutBounceD(time, from, to)
{
    --time /= 1f;
    to = to - from;

    if (time < (1 / 2.75f))
    {
        return 2f * to * 7.5625f * time;
    }

    if (time < (2 / 2.75f))
    {
        time -= (1.5f / 2.75f);
        return 2f * to * 7.5625f * time;
    }
    if (time < (2.5 / 2.75))
    {
        time -= (2.25f / 2.75f);
        return 2f * to * 7.5625f * time;
    }
    time -= (2.625f / 2.75f);
    return 2f * to * 7.5625f * time;
}

function OverdoneServers.EaseFunctions:EaseInOutBounceD(time, from, to)
{
    to = to - from;
    local d = 1;

    if (time < d * 0.5f)
    {
        return EaseInBounceD(0, to, time * 2) * 0.5f;
    }

    return EaseOutBounceD(0, to, time * 2 - d) * 0.5f;
}

function OverdoneServers.EaseFunctions:EaseInBackD(time, from, to)
{
    local s = 1.70158

    return 3f * (s + 1f) * (to - from) * time * time - 2f * s * (to - from) * time;
}

function OverdoneServers.EaseFunctions:EaseOutBackD(time, from, to)
{
    local s = 1.70158
    to = to - from;
    time -= 1;

    return to * ((s + 1f) * time * time + 2f * time * ((s + 1f) * time + s));
}

function OverdoneServers.EaseFunctions:EaseInOutBackD(time, from, to)
{
    float s = 1.70158f;
    to = to - from;
    time = time/.5

    if ((time) < 1)
    {
        s *= (1.525f);
        return 0.5f * to * (s + 1) * time * time + to * time * ((s + 1f) * time - s);
    }

    time -= 2;
    s *= (1.525f);
    return 0.5f * to * ((s + 1) * time * time + 2f * time * ((s + 1f) * time + s));
}

function OverdoneServers.EaseFunctions:EaseInElasticD(time, from, to)
{
    return EaseOutElasticD(from, to, 1f - time);
}

function OverdoneServers.EaseFunctions:EaseOutElasticD(time, from, to)
{
    to = to - from;

    local d = 1;
    const float p = d * .3f;
    float s;
    float a = 0;

    if (Math.Abs(a) < float.Epsilon || a < Mathf.Abs(to))
    {
        a = to;
        s = p * 0.25f;
    }
    else
    {
        s = p / (2 * Mathf.PI) * Mathf.Asin(to / a);
    }

    return (a * Mathf.PI * d * Mathf.Pow(2f, 1f - 10f * time) *
        Mathf.Cos((2f * Mathf.PI * (d * time - s)) / p)) / p - 5f * NaturalLogOf2 * a *
        Mathf.Pow(2f, 1f - 10f * time) * Mathf.Sin((2f * Mathf.PI * (d * time - s)) / p);
}

function OverdoneServers.EaseFunctions:EaseInOutElasticD(time, from, to)
{
    to = to - from;

    local d = 1;
    const float p = d * .3f;
    float s;
    float a = 0;

    if (Math.Abs(a) < float.Epsilon || a < Mathf.Abs(to))
    {
        a = to;
        s = p / 4;
    }
    else
    {
        s = p / (2 * Mathf.PI) * Mathf.Asin(to / a);
    }

    if (time < 1)
    {
        time -= 1;

        return -5f * NaturalLogOf2 * a * Mathf.Pow(2f, 10f * time) * Mathf.Sin(2 * Mathf.PI * (d * time - 2f) / p) -
            a * Mathf.PI * d * Mathf.Pow(2f, 10f * time) * Mathf.Cos(2 * Mathf.PI * (d * time - s) / p) / p;
    }

    time -= 1;

    return a * Mathf.PI * d * Mathf.Cos(2f * Mathf.PI * (d * time - s) / p) / (p * Mathf.Pow(2f, 10f * time)) -
        5f * NaturalLogOf2 * a * Mathf.Sin(2f * Mathf.PI * (d * time - s) / p) / (Mathf.Pow(2f, 10f * time));
}

function OverdoneServers.EaseFunctions:SpringD(time, from, to)
{
    time = Mathf.Clamp01(time);
    to = to - from;

    // Damn... Thanks http://www.derivative-calculator.net/
    // TODO: And it's a little bit wrong
    return to * (6f * (1f - time) / 5f + 1f) * (-2.2f * Mathf.Pow(1f - time, 1.2f) *
        Mathf.Sin(Mathf.PI * time * (2.5f * time * time * time + 0.2f)) + Mathf.Pow(1f - time, 2.2f) *
        (Mathf.PI * (2.5f * time * time * time + 0.2f) + 7.5f * Mathf.PI * time * time * time) *
        Mathf.Cos(Mathf.PI * time * (2.5f * time * time * time + 0.2f)) + 1f) -
        6f * to * (Mathf.Pow(1 - time, 2.2f) * Mathf.Sin(Mathf.PI * time * (2.5f * time * time * time + 0.2f)) + time
        / 5f);

}
*/
