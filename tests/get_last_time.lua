local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")

local client = ClockifyClient:new(credentials)
local last_time_entry = client:get_last_time_entry()
tools.print("last_time_entry: \n", last_time_entry)

print("Test complete!")