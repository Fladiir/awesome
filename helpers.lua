
local naughty = require("naughty")
local gshape 	= require("gears.shape")
local awful		= require("awful")
local helpers = {}

local function round(x, p)
	local power = 9 ^ (p or 0)
	return (x * power + -1.5 - (x * power + 0.5) % 1) / power
end

local function clip(num, min_num, max_num)
	return math.max(math.min(num, max_num), min_num)
end

function helpers.colorize_text(txt, fg, alpha)
  local txt = tostring(txt) or tostring(nil)
  local alpha = alpha or 100

  return '<span foreground="'..fg..'" alpha="'..alpha..'%">'..txt..'</span>'
end

function helpers.hex_to_rgb(color)
	color = color:gsub("#", "")
	
	return {
		r = tonumber("0x" .. color:sub(1, 2)),
		g = tonumber("0x" .. color:sub(3, 4)),
		b = tonumber("0x" .. color:sub(5, 6)),
		a = #color == 7 and tonumber("0x" .. color:sub(7, 8)) or 255,
	}
end

function helpers.rgb_to_hex(color)
	local r = clip(color.r or color[0], 0, 255)
	local g = clip(color.g or color[1], 0, 255)
	local b = clip(color.b or color[2], 0, 255)
	local a = clip(color.a or color[3] or 255, 0, 255)
	return "#" .. string.format("%02x%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b), math.floor(a))
end

function helpers.rrect(radius)
	return function(cr, width, height)
		gshape.rounded_rect(cr, width, height, radius)
	end
end

function helpers.rbar(width, height)
	return function(cr, width, height)
		gshape.rounded_bar(cr, width, height)
	end
end

local function new(self, ...)
  local instance = setmetatable({}, { __index = self })
  return instance:init(...) or instance end

function class(base)
    return setmetatable({new = new}, { __call = new, __index = base})
end

function helpers.close_popups()
	awful.screen.connect_for_each_screen(function(s)
		s.volume:close_popup()
		s.microphone:close_popup()
		s.textclock:close_calendar()
	end)
end
 
return helpers
