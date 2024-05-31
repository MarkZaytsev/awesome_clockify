local socket = require("socket")
local ClockifyClient = require("awesome_clockify.clockify_clientH")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")

local client = ClockifyClient:new(credentials)

--201 - success
local code, resume_resp = client:resume_timer()
print("code: "..code)
tools.print("resp: ", (resume_resp))

socket.sleep(5)

-- 200 - success
-- 404 - no active time entry
local code, stop_resp = client:stop_timer()
print("code: "..code)
tools.print("resp: ", stop_resp)


print("Test complete!")