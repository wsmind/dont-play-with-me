

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