local WebClient = require("web_client")
local tools = require("tools")
local credentials = require("tests.credentials")
local socket = require("socket")

local client = WebClient:new(credentials)

--201 - success
local code, resume_resp = client:resume_timer()
print("code: "..code)
print("resp: "..tools.print(resume_resp))

socket.sleep(5)

-- 200 - success
-- 404 - no active time entry
local code, stop_resp = client:stop_timer()
print("code: "..code)
print("resp: "..tools.print(stop_resp))


print("Test complete!")