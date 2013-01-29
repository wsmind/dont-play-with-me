require("math")

function math.clamp(k, nMin, nMax)
	return math.min(nMax, math.max(k, nMin))
end

function math.linearInterpolate(a, b, t)
	return a * (1 - t) + b * t
end

function math.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end