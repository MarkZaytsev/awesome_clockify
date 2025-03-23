local TestSetup = require("awesome_clockify.debug.clockify.test_setup")

local setup = TestSetup:new()
local last_time_entry = setup.client:get_last_time_entry()
setup.logger.log_table("last_time_entry: \n", last_time_entry)

setup.complete_test()