local awful = require("awful")
local wibox = require("wibox")
local lain = require("lain")
local theme = require("zenburn.theme")
local gears = require("gears")


local commands_path = os.getenv("HOME") .. "/.config/awesome/commands"
local colors = {
	separator = "#b16286",
	net_usage = "#b8bb26",
	cpu = "#fb4934",
	temperature = "#fabd2f",
	memory = "#b8bb26",
	clock = "#b8bb26",
}

local markup = lain.util.markup

-- Create a text clock widget
local mytextclock = wibox.widget.textclock(markup(colors.clock, "%d/%m/%Y - %T "), 1)
lain.widget.cal {
	attach_to = { mytextclock },
	notification_preset = {
		font = theme.font,
		bg = theme.bg_normal,
		fg = theme.fg_normal,
	}
}

local separator = wibox.widget.textbox(markup(colors.separator, "    "))

-- Create a net_usage widget
local net_usage_widget = wibox.widget.textbox()

-- Create a CPU usage widget
local cpu_widget = wibox.widget.textbox()

-- Create a temperature widget
local temp_widget = wibox.widget.textbox()

-- Create a memory usage widget
local mem_widget = wibox.widget.textbox()

-- Update the net_usage widget
local function update_net_usage_widget(widget)
	awful.spawn.easy_async("nu", function(stdout, stderr, reason, exit_code)
		widget:set_markup(markup(colors.net_usage, " " .. stdout))
	end)
end

-- Update the CPU usage widget
local function update_cpu_widget(widget)
	awful.spawn.easy_async(commands_path .. "/cpu_usage", function(stdout, stderr, reason, exit_code)
		widget:set_markup(markup(colors.cpu, " CPU " .. stdout))
	end)
end

-- Update the temperature widget
local function update_temp_widget(widget)
	awful.spawn.easy_async(commands_path .. "/temperature", function(stdout, stderr, reason, exit_code)
		widget:set_markup(markup(colors.temperature, " " .. stdout))
	end)
end

-- Update the memory usage widget
local function update_mem_widget(widget)
	awful.spawn.easy_async(commands_path .. "/memory", function(stdout, stderr, reason, exit_code)
		-- widget:set_text(markup(colors.memory, " F " .. stdout))
		widget:set_markup(markup(colors.memory, " F " .. stdout))
	end)
end


-- Create a textclock widget
screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox {
		screen  = s,
		buttons = {
			awful.button({}, 1, function() awful.layout.inc(1) end),
			awful.button({}, 3, function() awful.layout.inc(-1) end),
			awful.button({}, 4, function() awful.layout.inc(-1) end),
			awful.button({}, 5, function() awful.layout.inc(1) end),
		}
	}

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.noempty,
		buttons = {
			awful.button({}, 1, function(t) t:view_only() end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
			awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
		}
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate { context = "tasklist", action = "toggle_minimization" }
			end),
			awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
			awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
			awful.button({}, 5, function() awful.client.focus.byidx(1) end),
		}
	}

	-- Create the wibox
	s.mywibox = awful.wibar {
		position = "top",
		screen   = s,
		widget   = {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				mylauncher,
				s.mytaglist,
				s.mypromptbox,
			},
			s.mytasklist, -- Middle widget
			{          -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				-- mykeyboardlayout,
				net_usage_widget,
				separator,
				cpu_widget,
				separator,
				temp_widget,
				separator,
				mem_widget,
				separator,
				mytextclock,
				wibox.widget.systray(),
				-- mycal,
				s.mylayoutbox,
			},
		}
	}
end)

gears.timer {
	timeout = 10,
	autostart = true,
	call_now = true,
	callback = function()
		update_net_usage_widget(net_usage_widget)
		update_cpu_widget(cpu_widget)
		update_temp_widget(temp_widget)
		update_mem_widget(mem_widget)
	end,
}

-- }}}
