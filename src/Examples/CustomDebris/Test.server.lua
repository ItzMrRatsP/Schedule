local CustomDebris = require(script.Parent.CustomDebris)

local Part = Instance.new("Part")
Part.Anchored = true
Part.Name = "GunShot"
Part.CFrame = workspace.SpawnCFrame.CFrame * CFrame.new(0, 5, -5)
Part.Parent = workspace

CustomDebris:AddInstance(15, Part)

local NewPart = Instance.new("Part")
NewPart.Name = "test"
NewPart.Anchored = true
NewPart.CFrame = workspace.SpawnCFrame.CFrame * CFrame.new(0, 5, 5)
NewPart.Parent = workspace

CustomDebris:AddInstance(5, NewPart)
