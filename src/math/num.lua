require("math")

function math.clamp(k, nMin, nMax)
	return math.min(nMax, math.max(k, nMin))
end

function math.linearInterpolate(a, b, t)
	return a * (1 - t) + b * t
end