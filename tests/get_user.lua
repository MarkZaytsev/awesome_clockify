local WebClient = require("awesome_clockify.web_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")

local client = WebClient:new(credentials)
local user = client:get_user()
tools.print("user: \n", user)

print("Test complete!")