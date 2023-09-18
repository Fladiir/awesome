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

-- UI INCLUDES
local tbtn				= require("ui.buttons.text")

local calendar_w = class()

local function isLeapYear(year)
	if ((year % 4 == 0) and (year % 100 ~= 0)) or (year % 400 == 0) then
		return true
	end
	return false
end

local function getMonthDays(month, year)
	if month == 11 or month == 4 or month == 6 or month == 9 then
		return 30
	elseif month == 2 then
		if isLeapYear(year) then
			return 29
		end
		return 28
	else
		return 31
	end
	
end

local function day_widget(text, args)
	local w = wibox.widget({
			{
				halign 	= "center",
				valign 	= "center",
				font		= beautiful.font_nosize .. " 12",
				text 		= text,
				widget 	= wibox.widget.textbox
			},
			forced_height = dpi(60),
			bg 			= args.bg,
			fg			= args.fg,
			shape		= helpers.rrect(2),
			widget 	= wibox.container.background
		})

	return w
end

function calendar_w:set_current_date()
	self:set_date(os.date("*t"))
end

function calendar_w:decrease_month()
	if self.date.month == 1 then
		self:set_date({ year = self.date.year - 1, month = 12, day = self.date.day })
	else
		self:set_date({ year = self.date.year, month = self.date.month - 1, day = self.date.day })
	end
end

function calendar_w:increase_month()
	if self.date.month == 12 then
		self:set_date({ year = self.date.year + 1, month = 1, day = self.date.day })
	else
		self:set_date({ year = self.date.year, month = self.date.month + 1, day = self.date.day })
	end
end

function calendar_w:set_date(date)
	self.date = date

	local time = os.time({ year = date.year, month = date.month, day = 1})

	self.calendar_top_section.second.text = os.date("%B %Y", time)
	self.calendar_grid:reset()
	self:week_days()
	self:get_month_days()
end

function calendar_w:get_month_days()
	local current = os.date("*t")

	local first_week_day = os.date("*t", os.time({ year = self.date.year, month = self.date.month, day = 1}))
	local first_day_prev = getMonthDays(self.date.month - 1, self.date.year) - (first_week_day.wday - 1)

	for i = 1, first_week_day.wday - 1 do
		self.calendar_grid:add(day_widget(first_day_prev + i, { bg = beautiful.bar_bg, fg = beautiful.fg_disabled }))
	end

	for i = 1, getMonthDays(self.date.month, self.date.year) do
		if (current.year == self.date.year and current.month == self.date.month and current.day == i) then
			self.calendar_grid:add(day_widget(i, { bg = beautiful.accent, fg = beautiful.bar_fg }))
		else
			self.calendar_grid:add(day_widget(i, { bg = beautiful.bar_bg, fg = beautiful.bar_fg }))
		end
	end

	for i = 1, 42 - (getMonthDays(self.date.month, self.date.year) + (first_week_day.wday - 1)) do
		self.calendar_grid:add(day_widget(i, { bg = beautiful.bar_bg, fg = beautiful.fg_disabled }))
	end
end

function calendar_w:week_days()
	for i=1, 7 do
		self.calendar_grid:add(
			day_widget(beautiful.weekdays_layout[i], { bg = beautiful.bar_bg, fg = beautiful.bar_fg })
		)
	end
end

function calendar_w:get_anchor()
	if self.position == "left" then
		return "front"
	elseif self.position == "center" then
		return "middle"
	elseif self.position == "right" then
		return "back"
	else
		return "front"
	end
end

function calendar_w:init(s, args)


	local nbtn	= tbtn({ 
		text = "",
		font = beautiful.font_nosize .. " 20",
		bg = beautiful.bar_bg,
		fg = beautiful.bar_fg,
		ml = dpi(5),
		mr = dpi(5),
		mt = dpi(5),
		mb = dpi(5),
		on_press = function()
			self:increase_month()
		end
	})

	local pbtn	= tbtn({ 
		text = "",
		font = beautiful.font_nosize .. " 20",
		bg = beautiful.bar_bg,
		fg = beautiful.bar_fg,
		ml = dpi(5),
		mr = dpi(5),
		mt = dpi(5),
		mb = dpi(5),
		on_press = function()
			self:decrease_month()
		end
	})


	self.position = args.position

	self.cal = awful.popup {
		ontop								= true,
		visible							= true,
		type								= "dock",
		screen							= s,
		bg									= beautiful.bar_bg,
		fg									= beautiful.bar_fg,
		minimum_width				= beautiful.calendar_popup_width,
		maximum_width				= beautiful.calendar_popup_width,
		preferred_anchors		= self:get_anchor(),
		widget = wibox.widget({
			{
				{
					pbtn,
					{
						halign 	= "center",
						font		= beautiful.font_nosize .. " 12",
						text 		= os.date("%B %Y"),
						widget 	= wibox.widget.textbox
					},
					nbtn,
					expand = "inside",
					layout = wibox.layout.align.horizontal
				},
				{
					{
						homogeneous			= true,
						orientation			= "vertical",
						forced_num_cols	= 7,
						forced_num_rows	= 7,
						spacing					= dpi(10),
						expand					= true,
						layout 					= wibox.layout.grid
					},
					widget = wibox.widget.background
				},
				spacing = 10,
				layout 	= wibox.layout.fixed.vertical
			},
			margins = 10,
			widget 	= wibox.container.margin
		})
	}
	
	self.date = os.date("*t")
	self.calendar_top_section = self.cal.widget.widget.children[1]
	self.calendar_grid 				= self.cal.widget.widget.children[2].widget

	-- INITIALIZATION
	self:week_days()
	self:get_month_days()

	s:connect_signal("calendar::closed", function() 
		self:set_current_date() 
	end)
	return self.cal
end

return calendar_w
