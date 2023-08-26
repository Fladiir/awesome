local awful 			= require("awful")
local wibox 			= require("wibox")
local naughty			= require("naughty")
local gears				= require("gears")

local beautiful 	= require("beautiful")
local helpers 		= require("../helpers")
local animation		=	require("modules.animation")
local keybinds		= require("keys")
local xresources 	= require("beautiful.xresources")
local dpi 				= xresources.apply_dpi


local text_button = class()

function text_button:init(args)
	local button = wibox.widget({
		{
			{
				font		= args.font or beautiful.font,
				text		=	args.text,
				widget 	= wibox.widget.textbox
			},
			top					=	args.mt or 0,
			bottom			=	args.mb or 0,
			left				=	args.ml or 0,
			right				=	args.mr or 0,
			widget 			= wibox.container.margin
		},
		fg			= args.fg,
		bg			= args.bg,
		widget 	= wibox.container.background
	})

	self.hover_animation = animation:new({
		pos = helpers.hex_to_rgb(beautiful.bar_bg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(self, pos)
			button.bg = helpers.rgb_to_hex(pos)
		end,
	})

	self.hover_lost_animation = animation:new({
		pos = helpers.hex_to_rgb(beautiful.hoverbg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(self, pos)
			button.bg = helpers.rgb_to_hex(pos)
		end,
	})

	button:connect_signal("mouse::enter", function()
		self.hover_animation:set(helpers.hex_to_rgb(beautiful.hoverbg))
	end)

	button:connect_signal("mouse::leave", function()
		self.hover_lost_animation:set(helpers.hex_to_rgb(beautiful.bar_bg))
	end)

	button:connect_signal("button::press", args.on_press or function() end)

	return button
end

return text_button
