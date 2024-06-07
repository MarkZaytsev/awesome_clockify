local ClockifyClient = require("awesome_clockify.src.clockify_client")
local ClockifyController = require("awesome_clockify.src.controller")
local credentials = require("awesome_clockify.debug.credentials")
local logger = require("awesome_clockify.src.logger")
local tools = require("awesome_clockify.src.tools")

logger.is_active = true

local TestSetup = {}

function TestSetup:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.client = ClockifyClient:new(credentials)
	self.controller = ClockifyController:new{ clockify_client = self.client }
	self.logger = logger
	self.tools = tools
	return o
end

function TestSetup.complete_test()
	logger.log("Test complete!")
end

return TestSetup