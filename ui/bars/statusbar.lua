local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local bar_w = class()


function bar_w:set_widgets()


	if beautiful.textclock_position == "left" then
		self.layout.first:add(self.textclock)
	elseif beautiful.textclock_position == "center" then
		self.layout.second:add(self.textclock)
	else
		self.layout.third:insert(1, self.textclock)
	end

	if beautiful.taglist_position == "left" then
		self.layout.first:add(self.taglist)
	elseif beautiful.taglist_position == "center" then
		self.layout.second:add(self.taglist)
	else
		self.layout.third:insert(1, self.taglist)
	end
	
	if beautiful.utilsbar_position == "left" then
		self.layout.first:add(self.utilsbar)
	elseif beautiful.utilsbar_position == "center" then
		self.layout.second:add(self.utilsbar)
	else
		self.layout.third:insert(1, self.utilsbar)
	end
end

function bar_w:init(s)
   
    -- Create a textclock widget
    self.textclock = require("ui.widgets.textclock")(
			{screen = s, font = beautiful.textclock_font, calendar_position = beautiful.calendar_position }
		)
    
    -- Create a taglist widget
    self.taglist = require("ui.widgets.tags")(s)

		-- Create utilsbar
		self.utilsbar = require("ui.widgets.utilsbar")(s, { position = beautiful.utilsbar_position })

    self.bar = awful.wibar({ 
				ontop			= true,
				position = "top", 
				height = beautiful.wibar_size + beautiful.wibar_top_padding + beautiful.wibar_bot_padding, 
				screen = s})
    self.bar.bg = beautiful.bar_bg
    self.bar.fg = beautiful.bar_fg


    self.bar:setup {
			{
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{ -- Left widgets
						{
							left = dpi(10),
							widget = wibox.container.margin
						},
						nil,
						nil,
						expand = "none",
						layout = wibox.layout.fixed.horizontal,
				},
				{-- Middle widget
						layout = wibox.layout.fixed.horizontal,
				},
				{ -- Right widgets
						{
							left = dpi(10),
							widget = wibox.container.margin
						},
						layout = wibox.layout.fixed.horizontal,
						expand = "none",
				},
			},
			top = beautiful.wibar_top_padding,
			bottom = beautiful.wibar_bot_padding,
			widget = wibox.container.margin
    }
		self.layout = self.bar.widget.widget

		self:set_widgets()
end

return bar_w
