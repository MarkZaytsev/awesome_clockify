local socket = require("socket")
local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

local client = ClockifyClient:new(credentials)

--201 - success
local code, resume_resp = client:resume_timer()
logger.log("code: "..code)
tools.log_table("resp: ", resume_resp)

socket.sleep(5)

-- 200 - success
-- 404 - no active time entry
local code, stop_resp = client:stop_timer()
logger.log("code: "..code)
tools.log_table("resp: ", stop_resp)


logger.log("Test complete!")