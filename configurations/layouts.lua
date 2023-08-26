local awful = require("awful")

-- CLIENTS LAYOUTS
awful.layout.layouts = {
    awful.layout.suit.tile,
}

-- LAYOUT SIGNALS
client.connect_signal("request::manage", function (c)

    -- Set the windows at the slave,
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- FOCUS FOLLOWS MOUSE
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
