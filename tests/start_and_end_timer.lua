local socket = require("socket")
local WebClient = require("awesome_clockify.web_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")

local client = WebClient:new(credentials)

--201 - success
local code, resume_resp = client:resume_timer()
print("code: "..code)
print("resp: "..tools.print(resume_resp))

socket.sleep(5)

-- 200 - success
-- 404 - no active time entry
local code, stop_resp = client:stop_timer()
print("code: "..code)
print("resp: "..tools.print(stop_resp))


print("Test complete!")