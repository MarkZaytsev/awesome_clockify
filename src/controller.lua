local tools = require("awesome_clockify.src.tools")

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
	local active_seconds = self.clockify_client:get_active_time_seconds()
	self.start_time = os.time() - active_seconds
	self.is_running = active_seconds ~= 0
end

function Controller:get_text()
	if self.is_running and self.is_active_time_display_required then
		return self:get_active_time_text()
	else
		return self:get_today_tracked_time_text()
	end
end

function Controller:get_active_time_text()
	return os.date("!%X", self:get_active_time_seconds())
end

function Controller:get_active_time_seconds()
	if not self.is_running then
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
	self.is_running = true

	local result = self.clockify_client:toggle_timer()
	if not result.is_running then
	 	self.is_running = false
	 	self:update_total_tracked_seconds_today()
	end
end

function Controller:update_total_tracked_seconds_today()
	local today_start_time = tools.get_clockify_time_today_utc()
	self.total_tracked_seconds_today = self.clockify_client:get_total_seconds(today_start_time)
end

return Controller