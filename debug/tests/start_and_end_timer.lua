local socket = require("socket")
local TestSetup = require("awesome_clockify.debug.test_setup")

local setup = TestSetup:new()

--201 - success
local code, resume_resp = setup.client:resume_timer()
setup.logger.log("code: "..code)
setup.tools.log_table("resp: ", resume_resp)

socket.sleep(5)

-- 200 - success
-- 404 - no active time entry
local code, stop_resp = setup.client:stop_timer()
setup.logger.log("code: "..code)
setup.tools.log_table("resp: ", stop_resp)

setup.complete_test()