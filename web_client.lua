local https = require("ssl.https")
local ltn12 = require("ltn12")
local json = require("json")
local tools = require("tools")

local api_url = "https://api.clockify.me/api/v1"
local tracker_url = "https://clockify.me/tracker"

local WebClient = {}

function WebClient:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.user_url = api_url .. "/user"
	self.workspace_url = api_url .. "/workspaces/"..o.workspace_id
	self.workspace_user_url = self.workspace_url.."/user/"..o.user_id

	return o
end

function WebClient:request(method, url, payload)
	local response = {}
	local request = {
		url = url,
		method = method,
		sink = ltn12.sink.table(response),
		source = payload and ltn12.source.string(json.encode(payload)),
		headers = {
			["content-type"] = 'application/json',
		    ["x-api-key"] = self.api_key
		}
	}

	print("Request:\n"..tools.print(request))

	local _, code, body = https.request(request)
	return code, json.decode(response[1])
end

function WebClient:get(url)
	return self:request("GET", url)
end

function WebClient:post(url, payload)
	return self:request("POST", url, payload)
end

function WebClient:patch(url, payload)
	return self:request("PATCH", url, payload)
end

function WebClient:get_user()
	local code, response = self:get(self.user_url)

	return {
	    id = response["id"],
	    time_zone = response["settings"]["timeZone"],
	    default_workspace = response["defaultWorkspace"]
	}
end

function WebClient:get_last_time_entry()
	local code, response = self:get(self.workspace_user_url.."/time-entries?page-size=1")
	return response[1]
end

function WebClient:resume_timer()
	local last_time_entry = self:get_last_time_entry()

	payload = {
        description = last_time_entry["description"],
        tagIds = last_time_entry["tagIds"],
        start = tools.get_time_now_utc(),
        projectId = last_time_entry["projectId"]
    }

	return self:post(self.workspace_url.."/time-entries", payload)
end

function WebClient:stop_timer()
	payload = {
        ["end"] = tools.get_time_now_utc(),
    }

	return self:patch(self.workspace_user_url.."/time-entries", payload)
end

function WebClient:toggle_timer()
	local code, resp = self:stop_timer()
	if code == 404 then
		return self:resume_timer()
	end	

	return code, resp
end

return WebClient