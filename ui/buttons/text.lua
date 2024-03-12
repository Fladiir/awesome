local awful 			= require("awful")
local wibox 			= require("wibox")
local naughty			= require("naughty")
local gears				= require("gears")

local beautiful 	= require("beautiful")
local helpers 		= require("../helpers")
local animation		=	require("modules.animation")
local keybinds		= require("configurations.keys")
local xresources 	= require("beautiful.xresources")
local dpi 				= xresources.apply_dpi


local text_button = class()

function text_button:set_text(text)
	self.button.widget.widget.text = text
end

function text_button:init(args)
	self.hoverbg = args.hoverbg or beautiful.hoverbg
	self.hoverfg = args.hoverfg or beautiful.bar_fg

	self.button = wibox.widget({
		{
			{
				halign	= args.halign or "center",
				valign  = args.valign or "center",
				font		= args.font or beautiful.font,
				text		=	args.text,
				widget 	= wibox.widget.textbox
			},
			top						=	args.mt or 0,
			bottom				=	args.mb or 0,
			left					=	args.ml or 0,
			right					=	args.mr or 0,
			forced_height = args.forced_height or nil,
			forced_width	= args.forced_height or nil,
			widget 				= wibox.container.margin
		},
		fg			= args.fg,
		bg			= args.bg,
		shape		= args.shape or gears.shape.rectangle,
		widget 	= wibox.container.background
	})

	self.hover_animation = animation:new({
		pos = helpers.hex_to_rgb(args.bg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(item, pos)
			self.button.bg = helpers.rgb_to_hex(pos)
		end,
	})

	self.hover_fg_animation = animation:new({
		pos = helpers.hex_to_rgb(args.fg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(item, pos)
			self.button.fg = helpers.rgb_to_hex(pos)
		end,
	})

	self.hover_lost_animation = animation:new({
		pos = helpers.hex_to_rgb(self.hoverbg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(item, pos)
			self.button.bg = helpers.rgb_to_hex(pos)
		end,
	})

	self.hover_fg_lost_animation = animation:new({
		pos = helpers.hex_to_rgb(self.hoverfg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(item, pos)
			self.button.fg = helpers.rgb_to_hex(pos)
		end,
	})

	self.button:connect_signal("mouse::enter", function()
		self.hover_animation:set(helpers.hex_to_rgb(self.hoverbg))
		self.hover_fg_animation:set(helpers.hex_to_rgb(self.hoverfg))
	end)

	self.button:connect_signal("mouse::leave", function()
		self.hover_lost_animation:set(helpers.hex_to_rgb(args.bg))
		self.hover_fg_lost_animation:set(helpers.hex_to_rgb(args.fg))
	end)

	self.button:connect_signal("button::press", args.on_press or function() end)

	return self.button
end

return text_button
