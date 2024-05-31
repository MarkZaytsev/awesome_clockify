local https = require("ssl.https")
local ltn12 = require("ltn12")
local json = require("json")
local tools = require("awesome_clockify.tools")

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

	-- tools.print("Requset:\n", request)

	local _, code, body = https.request(request)
	return code, json.decode(response[1])
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