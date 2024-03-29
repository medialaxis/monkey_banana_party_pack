-- Get HOME environment variable
local home = os.getenv("HOME")

local function add_package_path(path)
    package.path = package.path .. ";" .. path .. "/?.lua"
    package.path = package.path .. ";" .. path .. "/?/init.lua"
end

-- Add paths to my plugins
add_package_path(string.format("%s/.local/share/awesome/plugins", home))

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Lain
local lain = require("lain")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init(string.format("%s/.config/awesome/theme.lua", home))

local terminal = "st"

-- Default modkey. Mod4 is the windows key.
local modkey = "Mod4"

-- Table of used layouts.
awful.layout.layouts = {
    awful.layout.suit.tile.left,
    lain.layout.centerwork,
    awful.layout.suit.max,
}

-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%Y-%m-%d W%V %a %H:%M:%S", 1)

-- Create a textbox widget
local mytextbox = wibox.widget.textbox()
awful.spawn.with_line_callback("my_status", {
    stdout = function(line)
        mytextbox:set_text(line)
    end
})

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    local root_color = beautiful.root_color or "#000000"
    gears.wallpaper.set(root_color)

    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper

        if type(wallpaper) == "function" then
            gears.wallpaper.maximized(wallpaper(s), s, true)
        else
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    local mylayoutbox = awful.widget.layoutbox(s)
    mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    local mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    }

    -- Create a tasklist widget
    local mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    local mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibar_height })

    -- Add widgets to the wibox
    mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mytaglist,
        },
        mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            mytextbox,
            mytextclock,
            wibox.widget.systray(),
            mylayoutbox,
        },
    }
end)

-- TODO(aedlund) this can be implemented by just swap (?)
local function swap_master()
    if client.focus == awful.client.getmaster() then
        awful.client.swap.byidx(1)
        awful.client.focus.byidx(-1)
    else
        awful.client.setmaster(client.focus)
    end
end

root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

local globalkeys = gears.table.join(
    -- Tag
    awful.key({ modkey,           }, "Tab", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Launcher
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey }, "p", function() awful.spawn("rofi -show combi -modes combi -combi-modes window,drun,run") end,
              {description = "run application", group = "launcher"}),
    awful.key({ modkey }, "c", function() awful.spawn("rofi -modi \"clipboard:greenclip print\" -show clipboard") end,
              {description = "run application", group = "launcher"}),
    awful.key({ modkey }, "w", function() awful.spawn("rofi -show window") end,
              {description = "show windows", group = "launcher"}),
    awful.key({ modkey }, "k", function() awful.spawn("xscreensaver-command -lock") end,
              {description = "lock screensaver", group = "launcher"}),

    -- Layout
    awful.key({ modkey,           }, "l",     function () awful.client.focus.bydirection("right")          end,
              {description = "focus right", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.client.focus.bydirection("left")          end,
              {description = "focus left", group = "layout"}),
    awful.key({ modkey,           }, "j",     function () awful.client.focus.bydirection("down")          end,
              {description = "focus down", group = "layout"}),
    awful.key({ modkey,           }, "k",     function () awful.client.focus.bydirection("up")          end,
              {description = "focus up", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Down",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Up",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),

    -- Client
    awful.key({ modkey, "Shift"   }, "Return",      swap_master,
              {description="swap master", group="client"}),
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.bydirection("left")    end,
              {description = "swap client left", group = "client"}),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.bydirection("right")    end,
              {description = "swap client right", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.bydirection("down")   end,
              {description = "swap client down", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.bydirection("up") end,
              {description = "swap client up", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Awesome
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Audio
    awful.key({ }, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
              {description = "mute audio", group = "audio"}),
    awful.key({ }, "XF86AudioRaiseVolume", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%") end,
              {description = "raise volume", group = "audio"}),
    awful.key({ }, "XF86AudioLowerVolume", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -1%") end,
                {description = "lower volume", group = "audio"})
)

local clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
     awful.key({ modkey,           }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "(un)maximize", group = "client"}),
    awful.key({ modkey,           }, "d", awful.client.floating.toggle,
        {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end,
        {description = "close", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    }
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
