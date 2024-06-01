local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

local client = ClockifyClient:new(credentials)

local code, toggle_resp = client:toggle_timer()
logger.log("code: "..code)
tools.log_table("resp: ", toggle_resp)

logger.log("Test complete!")