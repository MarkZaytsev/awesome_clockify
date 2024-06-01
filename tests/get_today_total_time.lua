local TestSetup = require("awesome_clockify.tests.test_setup")

local setup = TestSetup:new()

local today_start_time = setup.tools.get_time_today_utc()
local total_today_seconds = setup.client:get_total_seconds(today_start_time)
local total_today_time = os.date("!%X", total_today_seconds)

setup.logger.log("total_today_seconds: ", total_today_seconds)
setup.logger.log("total_today_time: ", total_today_time)

setup:complete()