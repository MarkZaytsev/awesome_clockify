local TestSetup = require("awesome_clockify.debug.clockify.test_setup")
local setup = TestSetup:new()

local toggle_resp = setup.client:toggle_timer()
setup.logger.log_table("resp: ", toggle_resp)

setup.complete_test()