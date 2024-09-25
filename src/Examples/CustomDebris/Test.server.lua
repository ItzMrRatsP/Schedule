local CustomDebris = require(script.Parent.CustomDebris)

local Part = Instance.new("Part")
Part.Anchored = true
Part.Name = "GunShot"
Part.Parent = workspace

CustomDebris:AddInstance(5, Part)

local NewPart = Instance.new("Part")
NewPart.Name = "test"
NewPart.Anchored = true
NewPart.Parent = workspace

CustomDebris:AddInstance(5, NewPart)
