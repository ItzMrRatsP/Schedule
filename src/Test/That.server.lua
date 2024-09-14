local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Schedule = require(ReplicatedStorage.Schedule).new()

local function AfterBoot(Player: Player)
	print(Player.Name .. " Joined the game!")
	warn("Update Leaderboard")
end

Players.PlayerAdded:Connect(function(Player: Player)
	Schedule:every(2):seconds():doThis(AfterBoot)
end)
