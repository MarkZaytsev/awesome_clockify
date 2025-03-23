local tools = require("awesome_clockify.src.clockify.tools")
local rest_client = require("awesome_clockify.src.rest_client")
local logger = require("awesome_clockify.src.logger")

local api_url = "https://api.clockify.me/api/v1"
local user_url = api_url .. "/user"

local Client = {}

function Client:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	assert(o.api_key, "No api_key provided for Client")
	self.headers = { ["x-api-key"] = o.api_key }
	
	if not o.workspace_id or not o.user_id then
		if not o.workspace_id then
			logger.log("No workspace_id provided for Client. Assuming default_workspace_id.")
		end

		if not o.user_id then
			logger.log("No user_id provided for Client. Assuming user_id from API token.")
		end

		local user = self.get_user(o)
		o.user_id = o.user_id or user.id
		o.workspace_id = o.workspace_id or user.default_workspace_id
	end
	
	self.workspace_url = api_url .. "/workspaces/"..o.workspace_id
	self.workspace_user_url = self.workspace_url .. "/user/" .. o.user_id

	return o
end

function Client:get_user()
	local response = rest_client.get(user_url, self.headers)

	return {
	    id = response["id"],
	    time_zone = response["settings"]["timeZone"],
	    default_workspace_id = response["defaultWorkspace"]
	}
end

function Client:get_last_time_entry()
	local response = rest_client.get(self.workspace_user_url.."/time-entries?page-size=1", self.headers)
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

	return rest_client.post(self.workspace_url.."/time-entries", self.headers, payload)
end

function Client:stop_timer()
	payload = {
        ["end"] = tools.get_clockify_time_now_utc()
    }

	return rest_client.patch(self.workspace_user_url.."/time-entries", self.headers, payload)
end

function Client:toggle_timer()
	local is_running = false
	local resp, code = self:stop_timer()
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
	return rest_client.get(self.workspace_user_url.."/time-entries?start="..start_time, self.headers)
end

function Client:get_entry_description(entry)
	return entry["description"]
end

local function get_entry_duration(entry)
	return entry["timeInterval"]["duration"]
end

local function is_entry_completed(entry)
	return not(get_entry_duration(entry) == nil)
end

local function get_entry_start_time(entry)
	return entry["timeInterval"]["start"]
end

function Client:get_total_seconds_from_completed_entries_today()
	local today_start_time = tools.get_clockify_time_today_utc()
	return get_total_seconds_from_completed_entries_since(today_start_time)
end

function Client:get_total_seconds_from_completed_entries_since(start_time)
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

function Client:get_running_entry_time_seconds()
	local entry = self:get_last_time_entry()
	return self:get_active_time_seconds_from_entry(entry)
end

function Client:get_active_time_seconds_from_entry(entry)
	if not entry then
		return 0
	end

	if is_entry_completed(entry) then
		return 0
	end

	local start_time = get_entry_start_time(entry)
	if not start_time then
		return 0
	end

	return tools.parse_clockify_time_to_seconds(start_time)
end

return Client