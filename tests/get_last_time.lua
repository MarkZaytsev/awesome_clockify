local WebClient = require("web_client")
local tools = require("tools")
local credentials = require("tests.credentials")

local client = WebClient:new(credentials)
local last_time_entry = client.get_last_time_entry()
print("last_time_entry: \n"..tools.print(last_time_entry))

print("Test complete!")