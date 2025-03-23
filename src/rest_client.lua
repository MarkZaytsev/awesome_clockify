local json = require("json")
local table_tools = require("awesome_clockify.src.table_tools")
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

function client.request(method, url, headers, payload)
	local request = {
		url = url,
		data = payload and json.encode(payload),
		headers = headers
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
		local is_susccess = nil
		is_susccess, json_response = pcall(function() return json.decode(text) end)
		
		if not is_susccess then
			logger.log("Error decoding response!")
			notify("Response decode failed!", "status_code: "..status_code..". Response: ["..text.."]. Decode error: "..decode_error)
		end
	else
		notify("Request failed!", "status_code: "..status_code..". Response: ["..text.."].")
	end

	return json_response, status_code
end

function client.get(url, headers)
	return client.request("GET", url, headers)
end

local function append_content_type(headers)
	local headers_copy = table_tools.shallow_copy(headers)
	headers_copy["content-type"] = 'application/json'
	return headers_copy
end

function client.post(url, headers, payload)
	return client.request("POST", url, append_content_type(headers), payload)
end

function client.patch(url, headers, payload)
	return client.request("PATCH", url, append_content_type(headers), payload)
end

function client.put(url, headers, payload)
	return client.request("PUT", url, append_content_type(headers), payload)
end

return client