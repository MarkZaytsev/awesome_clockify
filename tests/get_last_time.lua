local TestSetup = require("awesome_clockify.tests.test_setup")

local setup = TestSetup:new()
local last_time_entry = setup.client:get_last_time_entry()
setup.tools.log_table("last_time_entry: \n", last_time_entry)

setup:complete_test()