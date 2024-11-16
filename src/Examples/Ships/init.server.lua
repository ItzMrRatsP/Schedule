local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Schedule = require(ReplicatedStorage.Schedule).new()
local GameShip = nil

local function AddShip()
	GameShip = ReplicatedStorage.Ship:Clone()
	GameShip.Parent = workspace

	-- Output for the placing ship
	print("Placed the ship")
end

local function Attack()
	for _, Player in game.Players:GetPlayers() do
		if not Player.Character then continue end

		local Humanoid = Player.Character:FindFirstChild("Humanoid")

		if not Humanoid then continue end

		Humanoid:TakeDamage(35)
	end
end

local function RemoveShip()
	if not GameShip then return end

	GameShip:Destroy()
	print("Removed")
end

Schedule:Add(AddShip, 1)
Schedule:Add(Attack, 0.1) -- Damage player right after ship spawn
Schedule:Add(RemoveShip, 5)

Schedule:Run(true)
