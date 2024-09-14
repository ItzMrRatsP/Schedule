--!native
--!optimize 2
--!nocheck

local HttpService = game:GetService("HttpService")

local Schedule = {}
Schedule.Jobs = {} -- All active jobs that will be called

function Schedule.new(t: number?)
	local self = setmetatable({}, { __index = Schedule })

	self._queueId = HttpService:GenerateGUID(false)

	self.time = t
	self.timeScale = 1

	Schedule.Jobs[self._queueId] = self
	return self
end

function Schedule:seconds()
	self.timeScale = 1
	return self
end

function Schedule:minutes()
	self.timeScale = 60
	return self
end

function Schedule:hours()
	self.timeScale = 60 * 60
	return self
end

function Schedule:days()
	self.timeScale = 60 * 60 * 24
	return self
end

function Schedule:weeks()
	self.timeScale = 60 * 60 * 24 * 7
	return self
end

local function findIndex(job_id: string): number?
	for index, value in Schedule.Jobs do
		if not value.job_id then continue end
		if value.job_id == job_id then return index end
	end

	return nil
end

function Schedule:doThis(job, remove: boolean?, ...)
	if not self.timeScale then return end

	local wait_time = self.time * self.timeScale
	local job_id = HttpService:GenerateGUID(false)

	local wrapped = function(...)
		task.wait(wait_time)
		job(...)
	end

	table.insert(self.Jobs, {
		job = wrapped,
		remove_after = remove,
		job_id = job_id,
		args = { ... },
	})

	return job_id
end

function Schedule:run_once()
	for _, currentJob in self.Jobs[self._queueId] do
		if typeof(currentJob) ~= "table" then continue end

		currentJob.job(table.unpack(currentJob.args))
		if currentJob.remove_after then self:cancel_job(currentJob.job_id) end
	end
end

function Schedule:run_queue(): thread
	-- if not self.unit or not self.unitToTime[self.unit] then return end
	return task.spawn(function()
		while #self.Jobs[self._queueId] > 0 do
			self:run_once()
			task.wait()
		end
	end)
end

function Schedule:cancel_job(job_id: string)
	local jobIdToIndex = findIndex(job_id)

	if not jobIdToIndex then
		warn(
			"Job is not in the job list, Seems like you trying to remove something that doesn't exist!"
		)
		return
	end

	table.remove(self.Jobs, jobIdToIndex)
end

return Schedule
