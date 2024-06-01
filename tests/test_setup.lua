local ClockifyClient = require("awesome_clockify.clockify_client")
local ClockifyController = require("awesome_clockify.controller")
local credentials = require("awesome_clockify.tests.credentials")
local logger = require("awesome_clockify.logger")
local tools = require("awesome_clockify.tools")

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

function TestSetup:complete()
	self.logger.log("Test complete!")
end

return TestSetup