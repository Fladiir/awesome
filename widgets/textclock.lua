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
		self.calendar_toggled = false
    
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


		local calendar = require("widgets.calendar")(self.screen)
		
		self.on_toggle = animation:new({
			pos = -(calendar.height + 
				beautiful.wibar_size + beautiful.wibar_top_padding + beautiful.wibar_bot_padding),
			duration = 0.5,
			easing = animation.easing.inOutQuad,
			update = function(self, pos)
				calendar.y = pos
			end,
		})
		calendar.y = -500

		w:connect_signal("button::press", function(button)
			if self.calendar_toggled == true then
				self.on_toggle:set(-(calendar.height + 
					beautiful.wibar_size + beautiful.wibar_top_padding + beautiful.wibar_bot_padding))
				self.calendar_toggled = false
				self.screen:emit_signal("calendar::closed")
			else
				calendar:move_next_to(mouse.current_widget_geometry)	
				self.on_toggle:set(
					beautiful.wibar_size + 
					beautiful.wibar_top_padding + 
					beautiful.wibar_bot_padding )
				self.calendar_toggled = true
			end
		end)

    return w
end

return textclock_w
