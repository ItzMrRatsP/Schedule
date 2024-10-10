local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Schedule = require(ReplicatedStorage.Schedule)

local CustomDebris = {}
CustomDebris.Scheduler = Schedule.new()

-- For testing purpose

function CustomDebris:AddInstance(After: number, Object: Instance)
	if typeof(Object) ~= "Instance" then return end

	local _, JobId

	_, JobId = self.Scheduler:every(After):seconds():doThis(function()
		Object:Destroy()
		self.Scheduler:cancelJob(JobId)
	end)

	self.Scheduler:run()
end

return CustomDebris
