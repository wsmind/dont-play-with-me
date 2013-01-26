require("math")

function math.clamp(k, nMin, nMax)
	return math.min(nMax, math.max(k, nMin))
end