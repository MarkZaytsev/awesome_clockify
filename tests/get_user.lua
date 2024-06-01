local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

local client = ClockifyClient:new(credentials)
local user = client:get_user()
tools.log_table("user: \n", user)

logger.log("Test complete!")