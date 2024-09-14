-- Prototype
for _, Module in script:GetChildren() do
	if not Module:IsA("ModuleScript") then continue end

	pcall(function()
		require(Module)
	end)
end
