local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

local client = ClockifyClient:new(credentials)
local today_start_time = tools.get_time_today_utc()
local total_today_seconds = client:get_total_seconds(today_start_time)
local total_today_time = os.date("!%X", total_today_seconds)
logger.log("total_today_seconds: ", total_today_seconds)
logger.log("total_today_time: ", total_today_time)

logger.log("Test complete!")