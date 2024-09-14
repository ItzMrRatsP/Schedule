local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Schedule = require(ReplicatedStorage.Schedule)

Schedule.new(3):seconds():doThis(function()
	print("hello world")
end)

Schedule.new(0.35):seconds():doThis(function()
	print("after hello world")
end)

Schedule:run_queue()
