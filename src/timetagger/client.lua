local tools = require("awesome_clockify.src.tools")
local rest_client = require("awesome_clockify.src.rest_client")
local logger = require("awesome_clockify.src.logger")

local api_url = "http://localhost:8080/timetagger/api/v2/"

local Client = {}

function Client:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	assert(o.api_key, "No authtoken provided for Client")
	assert(o.api_url, "No api_url provided for Client")

	return o
end

function Client:get_last_time_entry()
	local _, response = rest_client.get(self.api_url.."/records?page-size=1", self.api_key)
	return response and response[1]
end

function Client:resume_timer()
	local last_time_entry = self:get_last_time_entry()

	payload = {
        description = last_time_entry["description"],
        tagIds = last_time_entry["tagIds"],
        start = tools.get_clockify_time_now_utc(),
        projectId = last_time_entry["projectId"]
    }

	return rest_client.post(self.workspace_url.."/time-entries", self.api_key, payload)
end

function Client:stop_timer()
	payload = {
        ["end"] = tools.get_clockify_time_now_utc()
    }

	return rest_client.patch(self.workspace_user_url.."/time-entries", self.api_key, payload)
end

function Client:toggle_timer()
	local is_running = false
	local code, resp = self:stop_timer()
	if code == 404 then
		is_running = true
		code, resp = self:resume_timer()
	end	

	return { 
		code = code,
		response = resp,
		is_running = is_running
	}
end

function Client:get_entries(start_time)
	local _, entries = rest_client.get(self.workspace_user_url.."/time-entries?start="..start_time, self.api_key)
	return entries
end

function Client:get_entry_description(entry)
	return entry["description"]
end

local function get_entry_duration(entry)
	return entry["timeInterval"]["duration"]
end

local function get_entry_start_time(entry)
	return entry["timeInterval"]["start"]
end

function Client:get_total_seconds(start_time)
	local entries = self:get_entries(start_time)
	local total_sec = 0
	for _,v in pairs(entries) do
		local duration = get_entry_duration(v)
		if duration then
			total_sec = total_sec + tools.get_duration_in_seconds(duration)
		end
	end
	
	return total_sec
end

function Client:get_active_time_seconds()
	local entry = self:get_last_time_entry()
	return self:get_active_time_seconds_from_entry(entry)
end

function Client:get_active_time_seconds_from_entry(entry)
	if not entry then
		return 0
	end

	local duration = get_entry_duration(entry)
	if duration then
		return 0
	end

	local start_time = get_entry_start_time(entry)
	if not start_time then
		return 0
	end

	return tools.parse_clockify_time_to_seconds(start_time)
end

return Client