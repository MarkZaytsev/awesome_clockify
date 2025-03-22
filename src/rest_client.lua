local https = require("ssl.https")
local ltn12 = require("ltn12")
local json = require("json")
local tools = require("awesome_clockify.src.tools")
local logger = require("awesome_clockify.src.logger")
local is_awesome_on, naughty = pcall(function() return require("naughty") end)

local client = {}

function client.request(method, url, api_key, payload)
	local response = {}
	local request = {
		url = url,
		method = method,
		sink = ltn12.sink.table(response),
		source = payload and ltn12.source.string(json.encode(payload)),
		headers = {
			["content-type"] = 'application/json',
		    ["x-api-key"] = api_key
		}
	}

	tools.log_table("Requset:\n", request)

	-- TODO run this request async or it will freeze the ui in case of time-out
	local _, code, body = https.request(request)
	
	logger.log("Response code: ", code)

	-- Response string is choped by characters amount for some reason
	local str_json = ""
	for _, v in pairs(response) do
		str_json = str_json .. v
	end

	logger.log("Response:\n", str_json)

	local status, json_response = pcall(function() return json.decode(str_json) end)
	
	-- TODO I need to understand what kind of response we get when things fails.
	-- It seems like request goes throught, then timeout happens in response
	if not status and is_awesome_on then
		naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Clockify response decode failed!",
                     text = "Code: "..code..". Response: ["..str_json.."]."})
	end

	return code, json_response
end

function client.get(url, api_key)
	return client.request("GET", url, api_key)
end

function client.post(url, api_key, payload)
	return client.request("POST", url, api_key, payload)
end

function client.patch(url, api_key, payload)
	return client.request("PATCH", url, api_key, payload)
end

return client