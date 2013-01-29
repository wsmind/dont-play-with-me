

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

function table.every(t, fn)
    for i = 1, #t do
        if not fn(t[i]) then
            return false
        end
    end
    return true
end

function table.max(t, fn)
	if not fn then
		fn = function(a,b) return a < b end
	end
	
    if #t == 0 then return nil, nil end
    local key, value = 1, t[1]
    for i = 2, #t do
        if fn(value, t[i]) then
            key, value = i, t[i]
        end
    end
    return {key, value}
end

function table.min(t)
	return table.max(t, function (a,b) return a > b end)
end