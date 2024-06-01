local wibox = require("wibox")
local gears = require("gears")
local Controller = require("awesome_clockify.controller")

local clockify_widget = {}

local function worker(user_args)
	local args = user_args or {}
	local width = args.width or 200
	
	assert(args.controller, "No controller provided to widget.")
	
	args.controller:initialize()

	clockify_widget = wibox.widget {
	        {
	            id = 'timer',
	            forced_width = width,
	            align = 'center',
	            widget = wibox.widget.textbox
	        },
	        layout = wibox.layout.fixed.horizontal,
	        set_timer_text = function(self, new_text)
	            self:get_children_by_id('timer')[1]:set_text(tostring(new_text))
	        end
	    }

	gears.timer {
		timeout   = 1,
	    call_now  = true,
	    autostart = true,
	    callback  = function()	
	    	clockify_widget:set_timer_text(args.controller:get_text())
	    end
	}
	return clockify_widget
end

return setmetatable(clockify_widget, { __call = function(_, ...)
    return worker(...)
end })