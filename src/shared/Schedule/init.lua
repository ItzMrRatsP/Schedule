local Scheduler = {}
Scheduler.__index = Scheduler

local Util = script.Util
local Output = require(script.Output)
local TableUtil = require(Util.TableUtil)

local SmallNumber = 1e-3

type Job = (...any) -> ()

type Data = {
	Run: Job,
	Arguments: any,
	Time: number,
	Running: boolean,
	Index: number,
}
type Events = { Data }

function Scheduler.new() -- New class
	return setmetatable({
		Jobs = {} :: Events,
		SortedJobs = {} :: { Data },
	}, Scheduler)
end

function Scheduler:Add(Job: (...any) -> (), Time: number, ...)
	-- Schedule an event to run after certain time
	if typeof(Job) ~= "function" then
		Output:Warn("InvalidTypeError", "Function")
		return
	end

	if self.Jobs[Job] then
		Output:Warn("AlreadyAdded")
		return -- Close the script already if the job is already there.
	end

	local LUT = TableUtil.toIndexedArray(self.Jobs)

	local Data: Data = {
		Run = nil,
		Arguments = { ... },
		Running = false,
		Time = (Time or 0) + (LUT[#LUT] and LUT[#LUT].Time or 0), -- (Time or 0) > Runs instantly after previous job / Runs instantly.
		Index = #LUT + 1,
	}

	Data.Run = function(...)
		-- Job is not running anymore
		Data.Running = true
		-- Wait the time then set job running to false
		task.wait(Data.Time)
		-- Job isn't running (waitting) anymore, we call the job after this
		Data.Running = false
		-- Just small checking if the job still exist so we can run it
		if not self.Jobs[Job] then
			return
		end
		-- Now we call the actual job
		Job(...)
	end

	self.Jobs[Job] = Data

	task.spawn(function()
		-- Sort the jobs
		self.SortedJobs = TableUtil.Sort(self.Jobs, function(a: Data, b: Data)
			return a.Index < b.Index
		end)
	end)
end

function Scheduler:Remove(Job: Job)
	local Data = self.Jobs[Job]

	if not Data then
		Output:Warn("NonExistingJob")
		return
	end

	self.Jobs[Job] = nil

	task.spawn(function()
		for _, ToOrder: Data in self.Jobs do
			if ToOrder.Index < Data.Index then
				continue
			end

			-- Remove one from the index
			ToOrder.Index -= 1
		end

		self.SortedJobs = TableUtil.Sort(self.Jobs, function(a: Data, b: Data)
			return a.Index < b.Index
		end)
	end)
end

local function CheckRunning(self, CheckIndex: number): boolean
	for Index, Data in self do
		if Index < CheckIndex then
			continue
		end

		if Data.Running then
			return true
		end
	end

	return false
end

function Scheduler:Run(Loop: boolean)
	if TableUtil.Size(self.Jobs) <= 0 then
		Output:Warn("NoJobsToRun")
		return
	end

	for Index, Data: Data in ipairs(self.SortedJobs) do
		-- Check if data is running, then we skip.
		if Data.Running then
			continue
		end

		-- Check if there is anything else running at the moment, then we cancel and wait the time again.
		if CheckRunning(self.SortedJobs, Index) then
			continue
		end

		task.spawn(Data.Run, table.unpack(Data.Arguments))
	end

	if not Loop then
		return
	end

	task.wait(SmallNumber) -- To avoid crashes
	self:Run(Loop)
end

function Scheduler:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return Scheduler
