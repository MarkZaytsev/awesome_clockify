local rest_client = require("awesome_clockify.src.rest_client")
local logger = require("awesome_clockify.src.logger")

local Client = {}

function Client:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	assert(o.api_key, "No authtoken provided for Client")
	assert(o.api_url, "No api_url provided for Client")
	self.headers = { authtoken = o.api_key }

	return o
end

function Client:get_last_time_entry()
	-- Approach is based on github.com/almarklein/timetagger_cli/blob/main/timetagger_cli/core.py#L67
	local now = os.time()
    local t1 = now - 35 * 60
    local t2 = now + 60
	local response = rest_client.get(self.api_url.."/records?timerange="..t1.."-"..t2, self.headers)
	local records = response["records"]
	return records and records[#records]
end

-- TODO adapt
function Client:resume_timer()
	local last_time_entry = self:get_last_time_entry()

	local payload = {
        description = last_time_entry["description"],
        tagIds = last_time_entry["tagIds"],
        start = tools.get_clockify_time_now_utc(),
        projectId = last_time_entry["projectId"]
    }

	-- local now = os.time()
	-- local payload = {
    --     "key": generate_uid(),
    --     "t1": now,
    --     "t2": now,
    --     "mt": now,
    --     "st": 0,
    --     "ds": selected_record["ds"],
    -- }

	return rest_client.post(self.workspace_url.."/time-entries", self.headers, payload)
end

-- TODO adapt
function Client:stop_timer()
	local payload = {
        ["end"] = tools.get_clockify_time_now_utc()
    }

	return rest_client.patch(self.workspace_user_url.."/time-entries", self.headers, payload)
end

-- TODO adapt
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

-- TODO adapt
function Client:get_entries(start_time)
	return rest_client.get(self.workspace_user_url.."/time-entries?start="..start_time, self.headers)
end

function Client:get_entry_description(entry)
	return entry["ds"]
end

local function get_entry_start_time(entry)
	return entry["t1"]
end

local function get_entry_end_time(entry)
	return entry["t2"]
end

local function is_entry_running(entry)
	local start_time = get_entry_start_time(entry)
	local end_time = get_entry_end_time(entry)
	return end_time == start_time
end

local function get_entry_duration(entry)
	local start_time = get_entry_start_time(entry)
	local end_time = get_entry_end_time(entry)
	return end_time - start_time
end

function Client:get_total_seconds_from_completed_entries_today()
	local today_start_time = os.time(os.date("!*t"))
	return get_total_seconds_from_completed_entries_since()
end

-- TODO adapt
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

	if is_entry_running(entry) then
		return os.time() - get_entry_start_time(entry)
	end

	return get_entry_duration(entry)
end

return Client