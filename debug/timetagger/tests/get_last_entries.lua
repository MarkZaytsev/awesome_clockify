local TestSetup = require("awesome_clockify.debug.timetagger.test_setup")

local setup = TestSetup:new()

--201 - success
local entry = setup.client:get_last_time_entry()
setup.logger.log_table("resp: ", entry)