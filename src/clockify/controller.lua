local tools = require("awesome_clockify.src.tools")

local Controller = {}

function Controller:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	assert(o.clockify_client, "No clockify_client provided to Controller.")

	self.total_tracked_seconds_today = 0
	self.is_entry_description_display_required = o.is_entry_description_display_required
	self.separator_character = "|" or o.separator_character
	return o
end

function Controller:initialize()
	self.is_initialized = true
	
	self:update_total_tracked_seconds_today()

	local entry = self.clockify_client:get_last_time_entry()
	local active_seconds = self.clockify_client:get_active_time_seconds_from_entry(entry)
	self.start_time = os.time() - active_seconds
	self.is_running = active_seconds ~= 0

	if self.is_running and self.is_entry_description_display_required then
		self.active_entry_description = self.clockify_client:get_entry_description(entry)
	end
end

function Controller:get_text()
	local text = self:get_time_text()
	if self.is_running and self.is_entry_description_display_required then
		return self:prepend_description_if_required(text)
	end

	return text
end

function Controller:get_time_text()
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

function Controller:prepend_description_if_required(text)
	if self.active_entry_description then 
		return self.active_entry_description .. self.separator_character .. text
	end
	return text
end

function Controller:toggle_timer()
	self.start_time = os.time()
	self.is_running = true

	local result = self.clockify_client:toggle_timer()
	if not result.is_running then
	 	self.is_running = false
	 	self:update_total_tracked_seconds_today()
	end

 	if self.is_entry_description_display_required then
		self.active_entry_description = self.clockify_client:get_entry_description(result.response)
	end
end

function Controller:update_total_tracked_seconds_today()
	local today_start_time = tools.get_clockify_time_today_utc()
	self.total_tracked_seconds_today = self.clockify_client:get_total_seconds(today_start_time)
end

return Controller