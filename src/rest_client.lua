local json = require("json")
local logger = require("awesome_clockify.src.logger")
local requests = require("awesome_clockify.src.requests")
local is_awesome_on, naughty = pcall(function() return require("naughty") end)

local client = {}

local function notify(title, text)
	if not is_awesome_on then
		return
	end

	naughty.notify({ 
		preset = naughty.config.presets.critical,
		title = title,
		text = text
	})
end

function client.request(method, url, api_key, payload)
	assert(client.api_key_header, "No api_key_header provided to rest_client.")

	local request = {
		url = url,
		data = payload and json.encode(payload),
		headers = {
			["content-type"] = 'application/json',
		    [client.api_key_header] = api_key
		}
	}

	logger.log_table("Requset:\n", request)

	-- TODO handle timeout. It causes awesome to stuck
	local response = requests.request(method, request)
	local status_code = response.status_code
	local text = response.text
	logger.log("Response status_code: ", status_code)
	logger.log("Response text: ", text)

	local json_response = nil
	if status_code == 200 or status_code == 201 then
		local decode_error = nil
		json_response, decode_error = response.json()
		
		if decode_error then
			logger.log("Error decoding response: "..decode_error)
			notify("Response decode failed!", "status_code: "..status_code..". Response: ["..text.."]. Decode error: "..decode_error)
		end
	else
		notify("Request failed!", "status_code: "..status_code..". Response: ["..text.."].")
	end

	return json_response, status_code
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