

function table.reduce(list, fn) 
    local acc
    for k, v in ipairs(list) do
        if 1 == k then
            acc = v
        else
            acc = fn(acc, v)
        end 
    end 
    return acc 
end

function table.sum(list)
	return table.reduce(
		list,
		function (a, b)
			return a + b
		end
	)
end

function table.slice (values,i1,i2)
	local res = {}
	local n = #values
	-- default values for range
	i1 = i1 or 1
	i2 = i2 or n
	
	if i2 < 0 then
		i2 = n + i2 + 1
	elseif i2 > n then
		i2 = n
	end
	
	if i1 < 1 or i1 > n then
	
	end
	
	local k = 1
	
	for i = i1,i2 do
		res[k] = values[i]
		k = k + 1
	end
	
	return res
end