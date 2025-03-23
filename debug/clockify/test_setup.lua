local ClockifyClient = require("awesome_clockify.src.clockify.client")
local controller = require("awesome_clockify.src.controller")
local credentials = require("awesome_clockify.debug.clockify.credentials")
local logger = require("awesome_clockify.src.logger")
local tools = require("awesome_clockify.src.clockify.tools")

logger.is_active = true

local TestSetup = {}

function TestSetup:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.client = ClockifyClient:new(credentials)
	self.controller = controller:new{ client = self.client }
	self.logger = logger
	self.tools = tools
	return o
end

function TestSetup.complete_test()
	logger.log("Test complete!")
end

return TestSetup