local mt = {
	__index = {
		merge = function(self, box)
			self.min = self.min:min(box.min)
			self.max = self.max:max(box.max)
		end,
		
		-- expand the AABB enough to include the given vector
		expand = function(self, vector)
			self.min = self.min:min(vector)
			self.max = self.max:max(vector)
		end,

        contains = function(self, vector)
            return vector.x >= min.x and vector.x <= max.x and vector.y >= min.y and vector.y <= max.y
        end,
		
		-- compute overlap for all possible collision planes
		-- then return the normal and collision depth for the smallest overlap
		-- return nil if no collision
		collide = function(self, box)
			local collisionInfo = {
				normal = nil,
				depth = nil
			}
			
			function testOverlap(overlap, normal)
				if overlap < 0 then
					return false
				end
				
				if (not collisionInfo.depth) or (overlap < collisionInfo.depth) then
					-- new minimal overlap found
					collisionInfo.depth = overlap
					collisionInfo.normal = normal
				end
				
				return true
			end
			
			if not testOverlap(self.max.x - box.min.x, vec2(1, 0)) then return nil end
			if not testOverlap(box.max.x - self.min.x, vec2(-1, 0)) then return nil end
			if not testOverlap(self.max.y - box.min.y, vec2(0, 1)) then return nil end
			if not testOverlap(box.max.y - self.min.y, vec2(0, -1)) then return nil end
			
			return collisionInfo
		end,
		
		-- debug draw (note: must be called from draw(), won't draw if called from update())
		drawDebug = function(self, r, g, b, a)
			love.graphics.setColor(r, g, b, a)
			love.graphics.rectangle("line", self.min.x, self.min.y, self.max.x - self.min.x, self.max.y - self.min.y)
		end
	}
}

function aabb(min, max)
	local box = {
        min = min,
        max = max
    }
    setmetatable(box, mt)
	return box
end
