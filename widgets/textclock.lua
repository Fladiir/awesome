local wibox = require("wibox")
local awful = require("awful")
local helpers = require("helpers")
local naughty = require("naughty")
local animation = require("modules.animation")
local beautiful = require("beautiful")


textclock_w = class()

function textclock_w:init(args)

    self.font = args.font
		self.screen = args.screen

		local month_calendar = awful.widget.calendar_popup.month({
			screen = args.screen
		})

    local w = wibox.widget({
				{
						font    = self.font,
						widget  = wibox.widget.textclock
				},
				shape = helpers.rrect(5),
        widget = wibox.container.background
    })

		w:connect_signal("mouse::enter", function()
			self.hover_animation:set(helpers.hex_to_rgb(beautiful.hoverbg))
		end)

		w:connect_signal("mouse::leave", function()
			self.hover_lost_animation:set(helpers.hex_to_rgb(beautiful.bar_bg))
		end)

		w:connect_signal("button::press", function(button)
		end)

		self.hover_animation = animation:new({
			pos = helpers.hex_to_rgb(beautiful.bar_bg),
			duration = 0.2,
			easing = animation.easing.linear,
			update = function(self, pos)
				w.bg = helpers.rgb_to_hex(pos)
			end,
		})

		self.hover_lost_animation = animation:new({
			pos = helpers.hex_to_rgb(beautiful.hoverbg),
			duration = 0.2,
			easing = animation.easing.linear,
			update = function(self, pos)
				w.bg = helpers.rgb_to_hex(pos)
			end,
		})


		month_calendar:attach(w.widget, "t", { on_hover = false })
		-- month_calendar:attach( w.widget, "tr" )
    return w
end

return textclock_w
