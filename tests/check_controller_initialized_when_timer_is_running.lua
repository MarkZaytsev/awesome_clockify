local socket = require("socket")
local TestSetup = require("awesome_clockify.tests.test_setup")

local setup = TestSetup:new()
setup.client:resume_timer()

socket.sleep(1)

setup.controller:initialize()

setup.logger.log("client active_time_seconds: ", setup.client:get_active_time_seconds())
setup.logger.log("controller.is_running: ", setup.controller.is_running)
setup.logger.log("controller.active_time_seconds: ", setup.controller:get_active_time_seconds())

setup:complete_test()