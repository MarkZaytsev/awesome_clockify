local socket = require("socket")
local TestSetup = require("awesome_clockify.debug.timetagger.test_setup")

local setup = TestSetup:new()

local entry = setup.client:toggle_timer()
setup.logger.log_table("Resuming with new entry: ", entry)

socket.sleep(5)

local entry, code = setup.client:toggle_timer()
setup.logger.log_table("Timer stopped with entry: ", entry)

setup.complete_test()