local TestSetup = require("awesome_clockify.debug.timetagger.test_setup")

local setup = TestSetup:new()

local total_today_seconds = setup.client:get_total_seconds_from_completed_entries_today()
local total_today_time = os.date("!%X", total_today_seconds)

setup.logger.log("Total today seconds from completed entries: ", total_today_seconds)
setup.logger.log("Total today time from completed entries: ", total_today_time)

setup.complete_test()