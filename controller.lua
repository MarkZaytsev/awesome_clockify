local tools = require("awesome_clockify.tools")

local Controller = {}

function Controller:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	assert(o.clockify_client, "No clockify_client provided to Controller.")

	self.total_tracked_seconds_today = 0
	return o
end

function Controller:initialize()
	self:update_total_tracked_seconds_today()	
end

function Controller:get_text()
	if self:is_running() and self.show_active_time then
		return self:get_active_time_text()
	else
		return self:get_today_tracked_time_text()
	end
end

function Controller:is_running()
	return self.start_time
end

function Controller:get_active_time_text()
	return os.date("!%X", self:get_active_time_seconds())
end

function Controller:get_active_time_seconds()
	if not self:is_running() then
		return 0
	end
	
	return os.time() - self.start_time
end

function Controller:get_today_tracked_time_text()
	local total_seconds = self.total_tracked_seconds_today + self:get_active_time_seconds() 
	return os.date("!%X", total_seconds)
end

function Controller:toggle_timer()
	self.start_time = os.time()

	local result = self.clockify_client:toggle_timer()
	if not result.is_running then
	 	self.start_time = nil
	 	self:update_total_tracked_seconds_today()
	end
end

function Controller:update_total_tracked_seconds_today()
	local today_start_time = tools.get_clockify_time_today_utc()
	self.total_tracked_seconds_today = self.clockify_client:get_total_seconds(today_start_time)
end

return Controller