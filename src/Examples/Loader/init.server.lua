local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Schedule = require(ReplicatedStorage.Schedule).new()

for _, Module in script:GetChildren() do
	if not Module:IsA("ModuleScript") then continue end

	pcall(function()
		Schedule:doThis(require(Module))
	end)
end

Schedule:run_once()
