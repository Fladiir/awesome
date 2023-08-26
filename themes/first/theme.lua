---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local naughty = require("naughty")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = "~/.config/awesome/themes/"

local theme = {}

theme.font_nosize						= "DejavuSansMono Nerd Font Bold"
theme.font                  = "DejavuSansMono Nerd Font Bold 10"
theme.taglist_buttons_font  = "DejavuSansMono Nerd Font" -- Size applied in taglist.lua
theme.textclock_font        = "DejavuSansMono Nerd Font Bold 12"
theme.systray_font          = "DejavuSansMono Nerd Font Bold 14"
theme.titlebar_font 				= "Noto Color Emoji" -- Dunno where size is applied

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(0)
theme.border_normal = "#000000"

theme.wibar_size = dpi(32)
theme.wibar_bot_padding = dpi(5)
theme.wibar_top_padding = dpi(5)
theme.bar_bg = "#0b0c10"
theme.bar_fg = "#ffffff"
theme.hoverbg = "#1f222e"
theme.accent = "#ee2244"
theme.fg_disabled = "#666666"

-- [[ WIDGETS

theme.calendar_popup_width = dpi(500) 

-- ]]

theme.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }

theme.taglist_occupied_color = "#dddddd"
theme.taglist_focused_color = "#ee2244"
theme.taglist_urgent_color = "#00ff00"
theme.taglist_empty_color = "#34384c"

theme.taglist_occupied_fontsize = 14
theme.taglist_empty_fontsize = 10

theme.taglist_tag_height 			= dpi(8)
theme.taglist_empty_width 		= dpi(8)
theme.taglist_occupied_width 	= dpi(16)
theme.taglist_selected_width 	= dpi(32)

theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)


theme.titlebar_close_button_normal = themes_path.."first/titlebar/close.png"
theme.titlebar_close_button_focus  = themes_path.."first/titlebar/close_red_alt.png"
theme.titlebar_maximized_button_normal_inactive = themes_path.."first/titlebar/maximize_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."first/titlebar/maximize_inactive.png"

theme.wallpaper = themes_path.."first/background.jpg"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
