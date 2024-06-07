local TestSetup = require("awesome_clockify.debug.test_setup")

local setup = TestSetup:new()
local user = setup.client:get_user()
setup.tools.log_table("user: \n", user)

setup.complete_test()