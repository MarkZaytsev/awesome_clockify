local ClockifyClient = require("awesome_clockify.clockify_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")

local client = ClockifyClient:new(credentials)
local user = client:get_user()
tools.print("user: \n", user)

print("Test complete!")