local TestSetup = require("awesome_clockify.tests.test_setup")
local setup = TestSetup:new()

local code, toggle_resp = setup.client:toggle_timer()
setup.logger.log("code: "..code)
setup.tools.log_table("resp: ", toggle_resp)

setup:complete_test()