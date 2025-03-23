local TestSetup = require("awesome_clockify.debug.timetagger.test_setup")

local setup = TestSetup:new()

local active_time_seconds = setup.client:get_active_time_seconds()
setup.logger.log("Active for: ", active_time_seconds, " seconds")
setup.complete_test()
