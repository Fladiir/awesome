-- BASE AWESOME LIBS
pcall(require, "luarocks.loader")
local gears = require("gears")
local beautiful = require("beautiful")

-- HELPERS
local helpers = require("helpers")

-- THEME
theme_selected = "first"
beautiful.init("~/.config/awesome/themes/" .. theme_selected .. "/theme.lua")

-- CONFIGURATIONS
require("configurations")

-- UI
require("ui")

