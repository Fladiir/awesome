local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local bar_w = class()


function bar_w:init(s)
   
    -- Create a textclock widget
    mytextclock = require("widgets.textclock")({screen = s, font = beautiful.textclock_font})
    
    -- Create a taglist widget
    s.mytaglist = require("widgets.tags")(s)

    s.bar = awful.wibar({ position = "top", 
				height = beautiful.wibar_size + beautiful.wibar_top_padding + beautiful.wibar_bot_padding, 
				screen = s})
    s.bar.bg = beautiful.bar_bg
    s.bar.fg = beautiful.bar_fg


    s.bar:setup {
        layout = wibox.layout.flex.horizontal,
				{
					{
						layout = wibox.layout.align.horizontal,
						expand = "none",
						-- forced_height = beautiful.wibar_size,
						{ -- Left widgets
								{
									left = dpi(10),
									widget = wibox.container.margin
								},
								expand = "none",
								layout = wibox.layout.fixed.horizontal,
						},
						{-- Middle widget
								s.mytaglist,
								layout = wibox.layout.fixed.horizontal,
						},
						{ -- Right widgets
								mytextclock,
								layout = wibox.layout.fixed.horizontal,
								expand = "none",
						},
					},
					top = beautiful.wibar_top_padding,
					bottom = beautiful.wibar_bot_padding,
					widget = wibox.container.margin
				}
    }
end

return bar_w
