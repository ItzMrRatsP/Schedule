local Players = game:GetService("Players")

local function SetupPlayer()
	for _, Player in Players:GetPlayers() do
		Player:SetAttribute("Money", 0)
	end

	Players.PlayerAdded:Connect(function(Player)
		Player:SetAttribute("Money", 0)
	end)
end

return SetupPlayer
