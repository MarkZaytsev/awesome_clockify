local TestSetup = require("awesome_clockify.tests.test_setup")

local setup = TestSetup:new()
setup.controller:initialize()

local client_active_seconds = setup.client:get_active_time_seconds()
setup.logger.log("client active_time_seconds: ", client_active_seconds)
assert(client_active_seconds == 0, "It seems like clockify timer is running.")

setup.logger.log("controller.is_running: ", setup.controller.is_running)
assert(setup.controller.is_running == false, "Controller is running!")

setup.logger.log("controller.start_time: ", setup.controller.start_time)

local controller_active_secconds = setup.controller:get_active_time_seconds()
setup.logger.log("controller.active_time_seconds: ", client_active_seconds)
assert(controller_active_secconds == 0, "Controller has active_time_seconds")

setup:complete_test()