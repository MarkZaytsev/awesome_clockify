local tools = require("awesome_clockify.tools")
local rest_client = require("awesome_clockify.rest_client")
local logger = require("awesome_clockify.logger")

local api_url = "https://api.clockify.me/api/v1"

local ClockifyClient = {}

function ClockifyClient:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	assert(o.api_key, "No api_key provided for ClockifyClient")
	assert(o.workspace_id, "No workspace_id provided for ClockifyClient")
	assert(o.user_id, "No user_id provided for ClockifyClient")

	self.user_url = api_url .. "/user"
	self.workspace_url = api_url .. "/workspaces/"..o.workspace_id
	self.workspace_user_url = self.workspace_url.."/user/"..o.user_id

	return o
end

function ClockifyClient:get_user()
	local code, response = rest_client.get(self.user_url, self.api_key)

	return {
	    id = response["id"],
	    time_zone = response["settings"]["timeZone"],
	    default_workspace = response["defaultWorkspace"]
	}
end

function ClockifyClient:get_last_time_entry()
	local _, response = rest_client.get(self.workspace_user_url.."/time-entries?page-size=1", self.api_key)
	return response and response[1]
end

function ClockifyClient:resume_timer()
	local last_time_entry = self:get_last_time_entry()

	payload = {
        description = last_time_entry["description"],
        tagIds = last_time_entry["tagIds"],
        start = tools.get_clockify_time_now_utc(),
        projectId = last_time_entry["projectId"]
    }

	return rest_client.post(self.workspace_url.."/time-entries", self.api_key, payload)
end

function ClockifyClient:stop_timer()
	payload = {
        ["end"] = tools.get_clockify_time_now_utc()
    }

	return rest_client.patch(self.workspace_user_url.."/time-entries", self.api_key, payload)
end

function ClockifyClient:toggle_timer()
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

function ClockifyClient:get_entries(start_time)
	local _, entries = rest_client.get(self.workspace_user_url.."/time-entries?start="..start_time, self.api_key)
	return entries
end

local function get_entry_duration(entry)
	return entry["timeInterval"]["duration"]
end

local function get_entry_start_time(entry)
	return entry["timeInterval"]["start"]
end

function ClockifyClient:get_total_seconds(start_time)
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

function ClockifyClient:get_active_time_seconds()
	local entry = self:get_last_time_entry()
	
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

return ClockifyClient