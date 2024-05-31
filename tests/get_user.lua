local WebClient = require("web_client")
local tools = require("tools")
local credentials = require("tests.credentials")

local client = WebClient:new(credentials)

local user = client.get_user()
print("user: \n"..tools.print(user))

print("Test complete!")