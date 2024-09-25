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
	self.timeScale = 0

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

	return false -- Couldn't find any job with given jobId
end

function Schedule:doThis(job, ...)
	local waitTime = (self.time or 0) * (self.timeScale or 0)
	local jobId = HttpService:GenerateGUID(false)

	local wrapped = function(it, ...)
		if it.state == "Busy" then return end -- Busy
		it.state = "Busy" -- Set state to busy

		task.wait(waitTime)

		it.state = "Waitting" -- Set state to waitting
		it.lastRunTime = os.clock()

		task.spawn(job, ...)
	end

	table.insert(self._jobs, {
		job = wrapped,
		jobId = jobId, -- It will only consider the first on the list
		state = "Waitting",
		args = { ... },
	})

	return self, jobId
end

function Schedule:run(loop: boolean)
	if #self.jobs <= 0 then return end

	for _, currentJob in self._jobs do
		if typeof(currentJob) ~= "table" then continue end
		task.spawn(currentJob.job, currentJob, table.unpack(currentJob.args))
	end

	if not loop then return end
	self:run(loop)
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
