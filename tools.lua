local tools = {}

function tools.print(o, depth)
	depth = depth or 1

	if type(o) == 'table' then
	  local s = '{ \n'
	  for k,v in pairs(o) do
	     if type(k) ~= 'number' then k = '"'..k..'"' end
	     s = s .. string.rep("\t", depth) .. '['..k..'] = ' .. tools.print(v, depth + 1) .. ',\n'
	  end
	  return s .. string.rep("\t", depth - 1) .. '}'
	else
	  return tostring(o)
	end
end

-- https://www.lua.org/pil/22.1.html
function tools.get_time_now_utc()
	return os.date("!%Y-%m-%dT%XZ")
end

return tools