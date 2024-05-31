local WebClient = require("web_client")
local tools = require("tools")
local credentials = require("tests.credentials")

local client = WebClient:new(credentials)

local code, toggle_resp = client:toggle_timer()
print("code: "..code)
print("resp: "..tools.print(toggle_resp))

print("Test complete!")