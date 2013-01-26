require("math.num")

local mt = {

	__add = function(a, b)
		return vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
	end,
	
	__sub = function(a, b)
		return vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
	end,
	
	__mul = function(a, b)
		if type(b) == "number" then
			return vec4(a.x * b, a.y * b, a.z * b, a.w * b)
		else
			return vec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
		end
	end,
	
	__div = function(a, b)
		if type(b) == "number" then
			return vec4(a.x / b, a.y / b, a.z / b, a.w / b)
		else
			return vec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
		end
	end,
	
	__unm = function(a)
		return vec4(-a.x, -a.y, -a.z, -a.w)
	end,
	
	__eq = function(a, b)
		return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w
	end,
	
	__lt = function(a, b)
		return a.x <= b.x and a.y <= b.y and a.z <= b.z and a.w == b.w
	end,
	
	__index = {
		asTable = function(self)
			return {self.x, self.y, self.z, self.w}
		end,
		
		linearInterpolate = function(self, v, t)
			return self * (1 - t) + v * t
		end,
		
		clamp = function(self, nmin, nmax)
			return vec4(math.clamp(self.x, nmin, nmax), math.clamp(self.y, nmin, nmax), math.clamp(self.z, nmin, nmax), math.clamp(self.w, nmin, nmax))
		end
		
		--[[dot = function(self, v)
			return self.x * v.x + self.y * v.y
		end,
		
		perp = function(self)
			return vec2(-self.y, self.x)
		end,
		
		length = function(self)
			return math.sqrt(self.x * self.x + self.y * self.y)
		end,
		
		normalize = function(self)
			local length = self:length()
			return vec2(self.x / length, self.y / length)
		end,
		
		reflect = function(self, normal)
			return normal * 2 * self:dot(normal) - self
		end,
		
		min = function(self, v)
			local min = vec2(self.x, self.y)
			if v.x < min.x then min.x = v.x end
			if v.y < min.y then min.y = v.y end
			return min
		end,
		
		max = function(self, v)
			local max = vec2(self.x, self.y)
			if v.x > max.x then max.x = v.x end
			if v.y > max.y then max.y = v.y end
			return max
		end]]--
	}
}

function vec4(x, y, z, w)
	local v = {x = x, y = y, z = z, w = w}
	setmetatable(v, mt)
	return v
end
