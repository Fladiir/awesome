-- SYSTEM INCLUDES
local awful			= require("awful")
local gears			= require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- CUSTOM INCLUDES
require(... .. ".notifications")

-- SET WALLPAPER FUNCTION
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local statusbar	= require(... .. ".bars.statusbar")

awful.screen.connect_for_each_screen(function(s)

    -- WALLPAPER
    set_wallpaper(s)

    -- TAG TABLES FOR EACH SCREEN
    awful.tag(beautiful.tagnames, s, awful.layout.layouts[1])
		
    -- STATUS BAR FOR EACH SCREEN
		statusbar(s)
end)
