local wibox		= require("wibox")
local awful		= require("awful")
local gears		= require("gears")
local naughty	= require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local animation = require("modules.animation")
local helpers = require("helpers")
local tbtn		= require("ui.buttons.text")

local volume_w = class()

local vol_icon 		= "󰕾"
local muted_icon	= "󰖁"

function volume_w:toggle_slider()
	if self.slider_toggled then
		self.on_toggle:set(dpi(0))
		self.update_timer:stop()
		self:close_popup()
	else
		self.on_toggle:set(dpi(100))
		self.update_timer:start()
	end
	self.slider_toggled = not self.slider_toggled
end

function volume_w:close_slider()
	if self.slider_toggled then
		self.on_toggle:set(dpi(0))
		self.update_timer:stop()
		self:close_popup()
	end
end

function volume_w:toggle_mute()
	if self.muted then
		awful.spawn.with_shell("pulsemixer --unmute")
		self.button.widget.widget.text = vol_icon
		self.muted = false
	else
		awful.spawn.with_shell("pulsemixer --mute")
		self.button.widget.widget.text = muted_icon
		self.muted = true 
	end
	--self.muted = not self.muted
end

function volume_w:get_mute()
	awful.spawn.easy_async_with_shell(
		"pulsemixer --get-mute", 
		function(stdout)
			local val = tonumber(stdout)
			if val == 0 then
				self.muted = false
			else
				self.muted = true
			end
			self.button.widget.widget.text = self.muted and muted_icon or vol_icon
		end
	)
end

function volume_w:update_slider(slider)
	awful.spawn.easy_async_with_shell(
		"pulsemixer --get-volume | awk -F' ' '{print $1}'", 
		function(stdout)
			local val = stdout
			if(val ~= nil) then
				local num = tonumber(val)
				--slider.value = num
				self.on_slider_change:set(num)
			end
		end
	)
end

function volume_w:populate_popup(panel)
	local function sink_widget(text, val, style)
		local w = tbtn({
			text =  text,
			halign = "left",
			bg = style.bg or beautiful.bar_bg,
			fg = style.fg or beautiful.bar_fg,
			ml = dpi(5),
			mr = dpi(5),
			mt = dpi(5),
			mb = dpi(5),
			shape = helpers.rrect(4),
			on_press = function()
				awful.spawn.with_line_callback("pactl set-default-sink " .. val, {
				exit = function() 
					awful.screen.connect_for_each_screen(function(o)
						o.volume:get_mute()
						o.volume:close_popup()
						o.volume.default_sink = val
					end)
				end})
			end
		})
		
		return w
	end
	
	panel.widget.widget:reset()

	awful.spawn.with_line_callback("pulsemixer --list-sinks", {
		stdout = function(line)
			local sink_id = string.match(line, "ID:%s+sink[-](%d-)%f[,]")
			local text = string.match(line, "Name:%s+(.-)%f[,]")
			if (sink_id ~= nil and text ~= nil) then
				panel.widget.widget:add(sink_widget(text, sink_id, 
					{ bg = (tonumber(sink_id) == tonumber(self.default_sink)) and beautiful.accent or nil }))
			end
		end
	})
end

function volume_w:close_popup()
	if self.popup_toggled then
		self.on_popup_open:set(
		-(self.vol_popup.height +
			beautiful.wibar_size +
			beautiful.wibar_top_padding +
			beautiful.wibar_bot_padding
			)
		)
		self.popup_togged = false
	end
end

function volume_w:toggle_popup()
	if self.popup_toggled then
		self.on_popup_open:set(
		-(self.vol_popup.height +
			beautiful.wibar_size +
			beautiful.wibar_top_padding +
			beautiful.wibar_bot_padding
			)
		)
	else
		self:populate_popup(self.vol_popup)
		self.vol_popup:move_next_to(mouse.current_widget_geometry)
		self.on_popup_open:set(
			beautiful.wibar_size +
			beautiful.wibar_top_padding +
			beautiful.wibar_bot_padding
		)
	end
	self.popup_toggled = not self.popup_toggled
end

function volume_w:get_anchor()
	if self.position == "left" then
		return "front"
	elseif self.position == "center" then
		return "middle"
	elseif self.position == "right" then
		return "back"
	else
		return "back"
	end
end

function volume_w:init(s,args)
	self.slider_toggled = false
	self.muted = false 
	self.popup_toggled = false
	self.screen = s
	self.position = args.position

	self.slider = wibox.widget {
		screen							= s,
    bar_shape           = gears.shape.rounded_rect,
    bar_height          = 6,
    bar_color           = beautiful.inactive_bar_color,
    bar_active_color    = beautiful.accent,
    handle_color        = "#ffffff",
    handle_shape        = gears.shape.circle,
    handle_border_width = 0,
		handle_width				= 0,
    value               = 0,
		forced_width				= dpi(0),
    widget              = wibox.widget.slider,
	}
	
	self:get_mute()
	self:update_slider(self.slider)

	awful.spawn.easy_async_with_shell("pactl list sinks short | grep $(pactl get-default-sink) | cut -f1",
		function(line) 
			self.default_sink = line 
		end
	)

	self.on_toggle = animation:new({
		pos = self.slider.forced_width,
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(item, pos)
			self.slider.forced_width = pos
		end,
	})

	self.on_slider_change = animation:new({
		pos = self.slider.value,
		duration = 0.2,
		easing = animation.easing.linear,
		update = function(item, pos)
			self.slider.value = pos
		end,
	})

	self.button = tbtn({
		text = self.muted and muted_icon or vol_icon,
		font = beautiful.icons_font .. " 26",
		bg = beautiful.bar_bg,
		fg = beautiful.bar_fg,
		ml = dpi(5),
		mr = dpi(5),
		mt = dpi(5),
		mb = dpi(5),
		shape = helpers.rrect(4),
		on_press = function(item, lx, ly, button)
			if button == 1 then
				self:update_slider(self.slider)
				if not self.muted then
					self:toggle_slider()
				end
			elseif button == 2 then
				awful.screen.connect_for_each_screen(function(o)
					o.volume:toggle_mute()
					o.volume:close_slider()
				end)
			elseif button == 3 then
				self:toggle_popup()
			end
		end
	})
	
	self.vol_popup = awful.popup {
		screen							= s,
		ontop								= true,
		visible							= true,
		type								= "dock",
		bg									= beautiful.bar_bg,
		fg									= beautiful.bar_fg,
		minimum_width				= beautiful.volume_popup_width,
		maximum_width				= beautiful.volume_popup_width,
		preferred_anchors		= self:get_anchor(),
		widget 	= {
				{
					spacing = 10,
					layout = wibox.layout.fixed.vertical
				},
				margins = 10,
				widget = wibox.container.margin
		}
	}

	self.on_popup_open = animation:new({
		pos = -200,
		duration = 0.5,
		easing = animation.easing.inOutQuad,
		update = function(item, pos)
			self.vol_popup.y = pos
		end,
	})

	self.w = wibox.widget({
		{
			self.button,
			self.slider,
			fill_space = false,
			spacing = dpi(5),
			layout = wibox.layout.fixed.horizontal
		},
		screen = s,
		widget = wibox.container.background
	})

	self.update_timer = gears.timer {
		timeout 	= 0.5,
		call_now 	= true,
		autostart	= false,
		callback	= function()
			self:update_slider(self.slider)
		end
	}

	self.slider:connect_signal("property::value", function(item, val)
		awful.spawn.with_shell("pulsemixer --set-volume " .. val)
	end)
	
	self.slider:connect_signal("button::press", function()
		self.update_timer:stop()
	end)

	self.slider:connect_signal("button::release", function()
		self.update_timer:start()
	end)

	s.volume = self
	
	return self.w
end


return volume_w
