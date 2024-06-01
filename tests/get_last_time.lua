local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

local client = ClockifyClient:new(credentials)
local last_time_entry = client:get_last_time_entry()
tools.log_table("last_time_entry: \n", last_time_entry)

logger.log("Test complete!")