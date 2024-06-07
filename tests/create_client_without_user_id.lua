local TestSetup = require("awesome_clockify.tests.test_setup")
local ClockifyClient = require("awesome_clockify.clockify_client")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

credentials.user_id = nil
local client = ClockifyClient:new(credentials)

TestSetup.complete_test()