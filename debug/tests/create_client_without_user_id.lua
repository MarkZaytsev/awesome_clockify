local TestSetup = require("awesome_clockify.debug.test_setup")
local ClockifyClient = require("awesome_clockify.src.clockify_client")
local credentials = require("awesome_clockify.debug.credentials")
local logger = require("awesome_clockify.src.logger")

logger.is_active = true

credentials.user_id = nil
local client = ClockifyClient:new(credentials)

TestSetup.complete_test()