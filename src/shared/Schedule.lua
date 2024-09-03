--[=[
	@class Schedule
	Schedule is an python based package that will allow you to run a job after certain amount of time!
]=]

local HttpService = game:GetService("HttpService")

local Schedule = {}

Schedule.__index = Schedule
Schedule.Jobs = {}

--[=[
@within Schedule
@method new

@param time: number?

This creates a new class for the Schedule
]=]

function Schedule.new(t: number?)
	return setmetatable({ time = t or 1, unit = 0 }, Schedule)
end

function Schedule:second()
	if self.time > 1 then
		warn("Use seconds method instead.")
		return
	end

	return self:seconds()
end

function Schedule:seconds()
	self.unit = 1
	return self
end

function Schedule:minute()
	if self.time > 1 then
		warn("Use minutes method instead.")
		return
	end

	return self:minutes()
end

function Schedule:minutes()
	self.unit = 60
	return self
end

function Schedule:hour()
	if self.time > 1 then
		warn("Use hours method instead.")
		return
	end

	return self:hours()
end

function Schedule:hours()
	self.unit = 60 * 60
	return self
end

function Schedule:day()
	if self.time > 1 then
		warn("Use days method instead.")
		return
	end

	return self:days()
end

function Schedule:days()
	self.unit = 60 * 60 * 24
	return self
end

function Schedule:week()
	if self.time > 1 then
		warn("Use weeks method instead.")
		return
	end

	return self:weeks()
end

function Schedule:weeks()
	self.unit = 60 * 60 * 24 * 7
	return self
end

local function hasJobs(): boolean
	local totalJobs = 0

	for _, _ in Schedule.Jobs do
		totalJobs += 1
	end

	return totalJobs > 0
end

local function findIndex(job_id: string): number?
	for index: number, value in Schedule.Jobs do
		if not value.job_id then continue end
		if value.job_id == job_id then return index end
	end

	return nil
end

function Schedule:doThis(job, remove: boolean?, ...)
	if self.Jobs[job] then return end
	if not self.unit then return end

	local wait_time = self.unit * self.time
	local job_id = HttpService:GenerateGUID(false)

	local wrapped = function(...)
		task.wait(wait_time)
		job(...)
	end

	table.insert(self.Jobs, {
		job = wrapped,
		remove_after = remove or false,
		job_id = job_id,
		args = { ... },
	})

	return job_id
end

function Schedule:run_queue(): thread
	-- if not self.unit or not self.unitToTime[self.unit] then return end
	return task.spawn(function()
		while hasJobs() do
			for _, currentJob in ipairs(self.Jobs) do
				if typeof(currentJob) ~= "table" then continue end
				currentJob.job(table.unpack(currentJob.args))

				if currentJob.remove_after then
					self:cancel_job(currentJob.job_id)
				end -- Remove the job after its called because i'd win!
			end

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

	-- warn(`Cancelled job with id **{job_id}**`)
	table.remove(self.Jobs, jobIdToIndex)
end

return Schedule
