local logger = {}

function logger.log(...)
	if logger.is_active then
		print(...)
	end
end

return logger