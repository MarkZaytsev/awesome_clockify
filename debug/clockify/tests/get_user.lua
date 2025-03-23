local TestSetup = require("awesome_clockify.debug.clockify.test_setup")

local setup = TestSetup:new()
local user = setup.client:get_user()
setup.logger.log_table("user: \n", user)

setup.complete_test()