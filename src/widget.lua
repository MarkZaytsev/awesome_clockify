local wibox = require("wibox")
local gears = require("gears")
local Controller = require("awesome_clockify.src.controller")
local beautiful = require("beautiful")

local clockify_widget = {}

local function worker(user_args)
	local args = user_args or {}
	local width = args.width or 110
	
	assert(args.controller, "No controller provided to widget.")
	
	clockify_widget = wibox.widget {
	    {
	        {
	            id = 'timer',
	            forced_width = width,
	            align = 'center',
	            widget = wibox.widget.textbox

	        },
	        layout = wibox.layout.fixed.horizontal,
	    },
	    bg = beautiful.bg_normal,
        widget = wibox.container.background,
        set_timer_text = function(self, new_text)
            self:get_children_by_id('timer')[1]:set_text(tostring(new_text))
        end
    }

	gears.timer {
		timeout   = 1,
	    call_now  = false,
	    autostart = true,
	    callback  = function()	
	    	-- We don't want to block rc.lua initialization waiting for API responses.
	    	-- Or break initialization with errors
	    	if not args.controller.is_initialized then
	    		args.controller:initialize()
	    	end

	    	clockify_widget:set_timer_text(args.controller:get_text())

	    	if args.controller.is_running then
	    		clockify_widget.bg = beautiful.bg_urgent
	    		clockify_widget.fg = beautiful.fg_urgent
		    else
		    	clockify_widget.bg = beautiful.bg_normal
		    	clockify_widget.fg = beautiful.fg_normal
		    end
	    end
	}
	return clockify_widget
end

return setmetatable(clockify_widget, { __call = function(_, ...)
    return worker(...)
end })