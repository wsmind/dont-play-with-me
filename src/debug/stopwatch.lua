require("socket")

local mt = {

	__index = {
		print = function(self, s)
			local ss = "[" .. self:getDuration() .. " ms] " .. s
			table.insert(self.history, ss)
			print(ss)
		end,
		
		buffer = function(self, s)
			table.insert(self.history, "[" .. self:getDuration() .. " ms] " .. s)
		end,
		
		printAll = function(self)
			for _,v in ipairs(self.history) do
				print(v)
			end
		end,
		
		printAllIf = function(self, cond)
			if (cond == nil and self.shouldPrintAll) or cond then
				self:printAll()
			end
		end,
		
		getDuration = function(self)
			return socket.gettime() * 1000 - self.origin
		end
	}
}

function stopwatch()
	local v = {
		origin = socket.gettime() * 1000,
		history = {},
		shouldPrintAll = false
	}
	setmetatable(v, mt)
	return v
end
