local tools = require("awesome_clockify.tools")
local rest_client = require("awesome_clockify.rest_client")

local api_url = "https://api.clockify.me/api/v1"

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

function WebClient:get_user()
	local code, response = rest_client.get(self.user_url, self.api_key)

	return {
	    id = response["id"],
	    time_zone = response["settings"]["timeZone"],
	    default_workspace = response["defaultWorkspace"]
	}
end

function WebClient:get_last_time_entry()
	local code, response = rest_client.get(self.workspace_user_url.."/time-entries?page-size=1", self.api_key)
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

	return rest_client.post(self.workspace_url.."/time-entries", self.api_key, payload)
end

function WebClient:stop_timer()
	payload = {
        ["end"] = tools.get_time_now_utc()
    }

	return rest_client.patch(self.workspace_user_url.."/time-entries", self.api_key, payload)
end

function WebClient:toggle_timer()
	local code, resp = self:stop_timer()
	if code == 404 then
		return self:resume_timer()
	end	

	return code, resp
end

return WebClient