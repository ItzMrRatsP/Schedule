local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Schedule = require(ReplicatedStorage.Schedule).new()

local function SetupPlayer()
	for _, Player in Players:GetPlayers() do
		Player:SetAttribute("Money", 0)
	end

	Players.PlayerAdded:Connect(function(Player)
		Player:SetAttribute("Money", 0)
	end)
end

return Schedule:doThis(SetupPlayer):run_once()
