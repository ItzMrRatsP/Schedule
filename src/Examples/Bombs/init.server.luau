local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Schedule = require(ReplicatedStorage.Schedule).new()

local Explosion = ServerStorage.Explosion

local RNG = Random.new()
local Bombs = {}

local function SpawnBombs()
	for index = 1, RNG:NextInteger(5, 15) do
		-- Create bomb
		local Bomb = Instance.new("Part")
		Bomb.Name = "Bomb"
		Bomb.Size = Vector3.one * 3
		Bomb.Shape = Enum.PartType.Ball
		Bomb.Color = Color3.new(0, 0, 0)
		Bomb.CFrame = CFrame.new(0, index * 2, 0)
		Bomb.Parent = workspace

		Bomb:ApplyImpulse(
			Vector3.new(
				RNG:NextInteger(-700, 700),
				0,
				RNG:NextInteger(-700, 700)
			)
		)

		Bombs[Bomb] = Bomb
	end
end

local function ExplodeAll()
	for _, bomb in Bombs do
		-- local exp = Explosion:Clone()
		-- exp:Emit(5)
		-- exp.Parent = bomb

		task.delay(0.15, function()
			bomb:Destroy()
		end)
	end
end

Schedule:every(1):seconds():doThis(SpawnBombs)
-- 2s after the spawn
Schedule:every(0.25):seconds():doThis(ExplodeAll)

-- Constant running unless all the jobs get cancelled.
Schedule:run_loop()
