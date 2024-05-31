local tools = {}

function tools.as_string(obj, depth)
	depth = depth or 1

	if type(obj) == 'table' then
	  local s = '{ \n'
	  for k,v in pairs(obj) do
	     if type(k) ~= 'number' then k = '"'..k..'"' end
	     s = s .. string.rep("\t", depth) .. '['..k..'] = ' .. tools.as_string(v, depth + 1) .. ',\n'
	  end
	  return s .. string.rep("\t", depth - 1) .. '}'
	else
	  return tostring(obj)
	end
end

function tools.print(text, obj)
	print(text..tools.as_string(obj))
end

-- https://www.lua.org/pil/22.1.html
function tools.get_time_now_utc()
	return os.date("!%Y-%m-%dT%XZ")
end

return tools