local socket = require("socket")
local TestSetup = require("awesome_clockify.tests.test_setup")

local setup = TestSetup:new()
setup.controller:toggle_timer()

for i=1,10 do
	socket.sleep(1)
	setup.logger.log("is_running: ", setup.controller.is_running)
	setup.logger.log("active_time_seconds: ", setup.controller:get_active_time_seconds())
end

setup.complete_test()