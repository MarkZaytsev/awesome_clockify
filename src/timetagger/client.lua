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

local function get_today_start_time()
	return os.time(os.date("!*t"))
end

local function get_now_time()
	return os.time()
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

-- TODO adapt
function Client:resume_timer()
	local last_time_entry = self:get_last_time_entry()

	local payload = {
        description = last_time_entry["description"],
        tagIds = last_time_entry["tagIds"],
        start = tools.get_clockify_time_now_utc(),
        projectId = last_time_entry["projectId"]
    }

	-- local now = get_now_time()
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

function Client:stop_timer()
	local last_entry = self:get_last_time_entry()
	if not is_entry_running(last_entry) then
		return nil, 404
	end

	last_entry["t2"] = get_now_time()
	return rest_client.put(self.api_url.."/records", self.headers, { last_entry })
end

-- TODO adapt
function Client:toggle_timer()
	local is_running = false
	local entry, code = self:stop_timer()
	if code == 404 then
		is_running = true
		entry = self:resume_timer()
	end	

	return { 
		entry = entry,
		is_running = is_running
	}
end

function Client:get_last_time_entry()
	local today_start_time = get_today_start_time()
	local entries = self:get_entries(today_start_time)
	return entries and entries[#entries]
end

function Client:get_entries(start_time)
    local end_time = get_now_time() + 60
	local response = rest_client.get(self.api_url.."/records?timerange="..start_time.."-"..end_time, self.headers)
	return response and response["records"]
end

function Client:get_entry_description(entry)
	return entry["ds"]
end

function Client:get_total_seconds_from_completed_entries_today()
	local today_start_time = get_today_start_time()
	return self:get_total_seconds_from_completed_entries_since(today_start_time)
end

function Client:get_total_seconds_from_completed_entries_since(start_time)
	local entries = self:get_entries(start_time)
	local total_sec = 0
	for _,v in pairs(entries) do
		total_sec = total_sec + get_entry_duration(v)
	end
	
	return total_sec
end

function Client:get_running_entry_time_seconds()
	local entry = self:get_last_time_entry()
	if not entry then
		return 0
	end

	if is_entry_running(entry) then
		return get_now_time() - get_entry_start_time(entry)
	end

	return 0
end

return Client