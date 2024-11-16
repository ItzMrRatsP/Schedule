local TableUtil = {}

function TableUtil.Size(TOC: { [any]: any })
	local Size = 0

	for _, _ in TOC do
		Size += 1
	end

	return Size
end

function TableUtil.toIndexedArray(TOC: { [any]: any }): { any }
	local Array = {}

	for _, Value in TOC do
		table.insert(Array, Value)
	end

	return Array
end

function TableUtil.Sort(TOC: { [any]: any }, Predict: (...any) -> boolean)
	local Array = TableUtil.toIndexedArray(TOC)

	table.sort(Array, function(a, b)
		return Predict(a, b)
	end)

	return Array
end

return TableUtil
