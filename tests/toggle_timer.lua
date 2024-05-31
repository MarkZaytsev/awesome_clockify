local WebClient = require("awesome_clockify.web_client")
local tools = require("awesome_clockify.tools")
local credentials = require("awesome_clockify.tests.credentials")

local client = WebClient:new(credentials)

local code, toggle_resp = client:toggle_timer()
print("code: "..code)
tools.print("resp: ", toggle_resp)

print("Test complete!")