local logger = require("awesome_clockify.logger")

local tools = {}

local tab = "\t"
local newline = "\n"
function tools.as_string(obj, depth)
	depth = depth or 1

	if type(obj) == 'table' then
	  local s = '{ '..newline
	  for k,v in pairs(obj) do
	     if type(k) ~= 'number' then k = '"'..k..'"' end
	     s = s .. string.rep(tab, depth) .. '['..k..'] = ' .. tools.as_string(v, depth + 1) .. ','..newline
	  end
	  return s .. string.rep(tab, depth - 1) .. '}'
	else
	  return tostring(obj)
	end
end

function tools.log_table(text, obj)
	logger.log(text..tools.as_string(obj))
end

-- Clockify format is "2024-06-01T05:00:50Z"
function tools.get_clockify_time_now_utc()
	return os.date("!%Y-%m-%dT%XZ")
end

function tools.get_clockify_time_today_utc()
	return os.date("!%Y-%m-%dT00:00:00Z")
end

function tools.parse_clockify_time_to_seconds(text)
	local _, _, year, month, day, hours, minutes, seconds = string.find(text, "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z")
	
	logger.log("year: ", year)
	logger.log("month: ", month)
	logger.log("day: ", day)
	logger.log("hours: ", hours)
	logger.log("minutes: ", minutes)
	logger.log("seconds: ", seconds)
	
	local time_passed = os.time{ 
		year = year,
		month = month,
		day = day,
		hour = hours,
		min = minutes,
		sec = seconds
	}

	tools.log_table("reverse date: ", os.date("%c", time_passed))
	return os.time(os.date("!*t")) - time_passed
end

local function extract(str, pattern)
	local start_pos, end_pos = string.find(str, pattern)
	if not start_pos then
		return 0
	end

	local str_value = string.sub(str, start_pos, end_pos - 1)
	return tonumber(str_value)
end

-- Clockify format is "PT4H20M50S", every component is optional. 
-- You can get "PT4H" or "PT20M50S" or "PT4H50S"
function tools.get_duration_in_seconds(str)
	local patterns = {"S", "M", "H"}
	local seconds = 0
	
	logger.log("parsing: "..str)

	for i,v in ipairs(patterns) do
		local temp = extract(str, "%d+"..v) * 60 ^ (i - 1)
		logger.log("\tgot "..temp.." seconds for "..v.." pattern ["..i.."]")
		seconds = seconds + temp
	end

	return seconds
end

return tools