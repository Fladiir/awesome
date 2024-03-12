local wibox = require("wibox")
local awful = require("awful")
local helpers = require("helpers")
local naughty = require("naughty")
local animation = require("modules.animation")
local beautiful = require("beautiful")

textclock_w = class()

function textclock_w:close_calendar()
	if self.calendar_toggled then
		self.on_toggle:set(-(self.calendar.height + 
			beautiful.wibar_size + beautiful.wibar_top_padding + beautiful.wibar_bot_padding))
		self.calendar_toggled = false
		self.screen:emit_signal("calendar::closed")
	end
end

function textclock_w:init(s, args)

    self.font = args.font
		self.screen = s
		self.calendar_toggled = false
		self.bg = args.bg or beautiful.bar_bg
		self.fg = args.fg or beautiful.bar_fg
    
		self.hover_bg = args.hover_bg or beautiful.hoverbg
		self.hover_fg = args.hover_fg or beautiful.bar_fg
		
		local w = wibox.widget({
				{
						font    = self.font,
						widget  = wibox.widget.textclock
				},
				bg = self.bg,
				fg = self.fg,
				shape = helpers.rrect(4),
        widget = wibox.container.background
    })

		w:connect_signal("mouse::enter", function()
			self.hover_animation:set(helpers.hex_to_rgb(self.hover_bg))
			self.hover_fg_animation:set(helpers.hex_to_rgb(self.hover_fg))
		end)

		w:connect_signal("mouse::leave", function()
			self.hover_lost_animation:set(helpers.hex_to_rgb(self.bg))
			self.hover_fg_lost_animation:set(helpers.hex_to_rgb(self.fg))
		end)


		self.hover_animation = animation:new({
			pos = helpers.hex_to_rgb(self.bg),
			duration = 0.2,
			easing = animation.easing.linear,
			update = function(self, pos)
				w.bg = helpers.rgb_to_hex(pos)
			end,
		})

		self.hover_lost_animation = animation:new({
			pos = helpers.hex_to_rgb(self.hover_bg),
			duration = 0.2,
			easing = animation.easing.linear,
			update = function(self, pos)
				w.bg = helpers.rgb_to_hex(pos)
			end,
		})


		self.hover_fg_animation = animation:new({
			pos = helpers.hex_to_rgb(self.fg),
			duration = 0.2,
			easing = animation.easing.linear,
			update = function(self, pos)
				w.fg = helpers.rgb_to_hex(pos)
			end,
		})

		self.hover_fg_lost_animation = animation:new({
			pos = helpers.hex_to_rgb(self.hover_fg),
			duration = 0.2,
			easing = animation.easing.linear,
			update = function(self, pos)
				w.fg = helpers.rgb_to_hex(pos)
			end,
		})

		local calendar = require("ui.widgets.calendar")(self.screen, {position = args.calendar_position})
		
		self.on_toggle = animation:new({
			pos = -500, 
			duration = 0.5,
			easing = animation.easing.inOutQuad,
			update = function(self, pos)
				calendar.y = pos
			end,
		})
		self.calendar = calendar
		calendar.y = -500

		w:connect_signal("button::press", function(button)
			if self.calendar_toggled == true then
				self.on_toggle:set(-(calendar.height + 
					beautiful.wibar_size + beautiful.wibar_top_padding + beautiful.wibar_bot_padding))
				self.calendar_toggled = false
				self.screen:emit_signal("calendar::closed")
			else
				calendar:move_next_to(mouse.current_widget_geometry)	
				helpers:close_popups()
				self.on_toggle:set(
					beautiful.wibar_size + 
					beautiful.wibar_top_padding + 
					beautiful.wibar_bot_padding )
				self.calendar_toggled = true
			end
		end)

		s.textclock = self

    return w
end

return textclock_w
