local wibox		= require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")

local network_w = class()

function network_w:init(s, args)
	self.w = wibox.widget({
		forced_width = dpi(30),
		bg = "#00ff00",
		widget = wibox.container.background
	})

	return self.w
end


return network_w
