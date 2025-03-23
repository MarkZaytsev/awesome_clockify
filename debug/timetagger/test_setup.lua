local TimeTaggerClient = require("awesome_clockify.src.timetagger.client")
local TimeTaggerController = require("awesome_clockify.src.timetagger.controller")
local credentials = require("awesome_clockify.debug.timetagger.credentials")
local logger = require("awesome_clockify.src.logger")

logger.is_active = true

local TestSetup = {}

function TestSetup:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	self.client = TimeTaggerClient:new(credentials)
	self.controller = TimeTaggerController:new{ client = self.client }
	self.logger = logger
	return o
end

function TestSetup.complete_test()
	logger.log("Test complete!")
end

return TestSetup