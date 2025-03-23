local TestSetup = require("awesome_clockify.debug.clockify.test_setup")
local setup = TestSetup:new()

local toggle_resp, code = setup.client:toggle_timer()
setup.logger.log("code: "..code)
setup.logger.log_table("resp: ", toggle_resp)

setup.complete_test()