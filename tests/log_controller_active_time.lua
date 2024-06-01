local socket = require("socket")
local ClockifyClient = require("awesome_clockify.clockify_client")
local ClockifyController = require("awesome_clockify.controller")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")

logger.is_active = true

local client = ClockifyClient:new(credentials)
local controller = ClockifyController:new{	clockify_client = client }

controller:toggle_timer()

for i=1,10 do
	socket.sleep(1)
	logger.log("is_running: ", controller:is_running())
	logger.log("active_time_seconds: ", controller:get_active_time_seconds())
end

logger.log("Test complete!")