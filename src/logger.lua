local logger = {}

function logger.log(...)
	if logger.is_active then
		print(...)
	end
end

local tab = "\t"
local newline = "\n"
function logger.as_string(obj, depth)
	if not logger.is_active then
		return
	end

	depth = depth or 1

	if type(obj) == 'table' then
	  local s = '{ '..newline
	  for k,v in pairs(obj) do
	     if type(k) ~= 'number' then k = '"'..k..'"' end
	     s = s .. string.rep(tab, depth) .. '['..k..'] = ' .. logger.as_string(v, depth + 1) .. ','..newline
	  end
	  return s .. string.rep(tab, depth - 1) .. '}'
	else
	  return tostring(obj)
	end
end

function logger.log_table(text, obj)
	if not logger.is_active then
		return
	end
	
	logger.log(text..logger.as_string(obj))
end

return logger