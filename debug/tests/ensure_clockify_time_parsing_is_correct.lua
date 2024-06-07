local TestSetup = require("awesome_clockify.debug.test_setup")

local setup = TestSetup:new()

local clockify_time = setup.tools.get_clockify_time_now_utc()
local delta_seconds = setup.tools.parse_clockify_time_to_seconds(clockify_time)

assert(delta_seconds == 0, "delta_seconds must be zero")

setup.complete_test()