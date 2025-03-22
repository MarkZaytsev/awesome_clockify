local TestSetup = require("awesome_clockify.debug.clockify.test_setup")
local ClockifyClient = require("awesome_clockify.src.clockify.client")
local credentials = require("awesome_clockify.debug.clockify.credentials")
local logger = require("awesome_clockify.src.logger")

logger.is_active = true

credentials.workspace_id = nil
local client = ClockifyClient:new(credentials)

TestSetup.complete_test()