local TestSetup = require("awesome_clockify.debug.clockify.test_setup")

local setup = TestSetup:new()

local today_start_time = setup.tools.get_clockify_time_today_utc()
local total_today_seconds = setup.client:get_total_seconds_from_completed_entries_since(today_start_time)
local total_today_time = os.date("!%X", total_today_seconds)

setup.logger.log("Total today seconds from completed entries: ", total_today_seconds)
setup.logger.log("Total today time from completed entries: ", total_today_time)

setup.complete_test()