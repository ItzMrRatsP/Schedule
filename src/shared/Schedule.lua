--!native
--!optimize 2
--!nocheck

local HttpService = game:GetService("HttpService")

local Schedule = {}

function Schedule.new()
	return setmetatable({ _jobs = {} }, { __index = Schedule })
end

function Schedule:every(t: number?)
	self.time = t
	self.timeScale = 1

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

function Schedule:findJob(jobId: string): number?
	for index, job in self._jobs do
		if job.jobId ~= jobId then continue end
		return index
	end

	warn(`Couldn't find any job with the jobId: {jobId}`)
	return false -- Couldn't find any job with given jobId
end

function Schedule:doThis(job, ...)
	if not self.timeScale then return end

	local wait_time = self.time * self.timeScale
	local jobId = HttpService:GenerateGUID(false)

	local wrapped = function(...)
		task.wait(wait_time)
		job(...)
	end

	table.insert(self._jobs, {
		job = wrapped,
		jobId = jobId, -- It will only consider the first on the list
		args = { ... },
	})

	return jobId
end

function Schedule:run_once()
	for _, currentJob in self._jobs do
		if typeof(currentJob) ~= "table" then continue end
		currentJob.job(table.unpack(currentJob.args))
	end
end

function Schedule:run_loop(): thread
	return task.spawn(function()
		while #self._jobs > 0 do
			self:run_once()
			task.wait()
		end
	end)
end

function Schedule:cancel_job(jobId: string)
	local jobIdToIndex = self:findJob(jobId)

	if not jobIdToIndex then
		warn(
			"Job is not in the job list, Seems like you trying to remove something that doesn't exist!"
		)
		return
	end

	table.remove(self._jobs, jobIdToIndex)
end

return Schedule