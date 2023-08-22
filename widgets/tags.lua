local awful 		= require("awful")
local wibox 		= require("wibox")
local naughty		= require("naughty")
local gears			= require("gears")

local beautiful = require("beautiful")
local helpers 	= require("../helpers")
local animation	=	require("modules.animation")
local keybinds	= require("keys")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local taglist_w = class()


function taglist_w:tag_update(item, tag, index)
end


function taglist_w:widget_template()
	local w = {
		widget 					= wibox.container.margin,
		forced_width 		= dpi(30),
		forced_height 	= dpi(20),
		create_callback = function(item, tag, index, _)
			local c = wibox.widget({
				widget = wibox.container.place,
				valign = "center",
				{
					widget 				= wibox.container.background,
					forced_height = beautiful.taglist_tag_height,
					shape					=	gears.shape.rounded_bar,
				},
			})

			item:set_widget(c)

			item.tag_animation = animation:new({
				duration	=	0.125,
				easing		= animation.easing.linear,
				update		=	function(self, pos)
					c:get_children()[1].forced_width = dpi(pos)
				end,
			})

			local t = item.widget:get_children()[1]
			
			if tag.selected then
				item.tag_animation:set(beautiful.taglist_selected_width)
				t.bg 		= beautiful.taglist_focused_color
			elseif #tag:clients() == 0 then
				item.tag_animation:set(beautiful.taglist_empty_width)
				t.bg 		= beautiful.taglist_empty_color
			else
				item.tag_animation:set(beautiful.taglist_occupied_width)
				t.bg 		= beautiful.taglist_empty_color
			end
		end,

		update_callback = function(item, tag, index, _)
			local t = item.widget:get_children()[1]

			if tag.selected then
				item.tag_animation:set(beautiful.taglist_selected_width)
				t.bg 		= beautiful.taglist_focused_color
			elseif #tag:clients() == 0 then
				item.tag_animation:set(beautiful.taglist_empty_width)
				t.bg 		= beautiful.taglist_empty_color
			else
				item.tag_animation:set(beautiful.taglist_occupied_width)
				t.bg 		= beautiful.taglist_empty_color
			end
		end
	}

	return w
end

function taglist_w:init(s, args)

	local taglist = awful.widget.taglist ({
		screen 					= s,
		filter 					= awful.widget.taglist.filter.all,
		buttons					=	keybinds.taglist_buttons,
		widget_template = self:widget_template()
	})

	local widget = wibox.widget({
		widget 	= wibox.container.background,
		bg			= beautiful.bar_bg,
		shape		= helpers.rrect(5),
		{
			widget = wibox.container.margin,
			left	= dpi(5),
			right = dpi(5),
			taglist
		}
	})

	--widget:set_widget(taglist)
	
	self.on_hover = animation:new({
		pos = helpers.hex_to_rgb(beautiful.bar_bg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(self, pos)
			widget.bg = helpers.rgb_to_hex(pos)
		end,
	})

	self.on_hover_lost = animation:new({
		pos = helpers.hex_to_rgb(beautiful.hoverbg),
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(self, pos)
			w.bg = helpers.rgb_to_hex(pos)
		end,
	})

	widget:connect_signal("mouse::enter", function()
		self.on_hover:set(helpers.hex_to_rgb(beautiful.hoverbg))
	end)

	widget:connect_signal("mouse::leave", function()
		self.on_hover:set(helpers.hex_to_rgb(beautiful.bar_bg))
	end)

	return widget
end

return taglist_w
