local https = require("ssl.https")
local ltn12 = require("ltn12")
local json = require("json")
local tools = require("awesome_clockify.src.tools")
local logger = require("awesome_clockify.src.logger")

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

	local _, code, body = https.request(request)
	
	-- Response string is choped by characters amount for some reason
	local str_json = ""
	for _, v in pairs(response) do
		str_json = str_json .. v
	end

	logger.log("response:\n", str_json)

	return code, json.decode(str_json)
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