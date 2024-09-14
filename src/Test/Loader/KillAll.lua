local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Schedule = require(ReplicatedStorage.Schedule).new()

local function AfterBoot()
	while true do
		print("Prototype running!")
		task.wait(3)
	end
end

return Schedule:doThis(AfterBoot):run_once()
