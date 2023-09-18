local wibox		= require("wibox")
local naughty	= require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")

local utilsbar_w = class()

function utilsbar_w:init(s, args)

	self.volume = require("ui.widgets.utils.volume")(s, {position = args.position})
	self.w = wibox.widget({
		{
			self.volume,
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.background
	})

	--local utils = require("ui.widgets.utils")
	--for _,value in pairs(utils) do
	--	self.w.widget:add(value(s))
	--end
	
	return self.w
end


return utilsbar_w
