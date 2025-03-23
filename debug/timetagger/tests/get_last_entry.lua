local TestSetup = require("awesome_clockify.debug.timetagger.test_setup")

local setup = TestSetup:new()

local entry = setup.client:get_last_time_entry()
setup.logger.log_table("Entry: ", entry)
setup.complete_test()