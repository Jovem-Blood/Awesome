local awful = require("awful")

-- Function to handle key events in resize mode
local function resize_handler(mod, key, event)
	if event == "release" then return end

	if key == "h" then
		-- Resize the focused client to the left
		awful.client.incwfact(0.1)
	elseif key == "j" then
		-- Resize the focused client down
		awful.client.incfwfact(-0.1)
	elseif key == "k" then
		-- Resize the focused client up
		awful.client.incfwfact(0.1)
	elseif key == "l" then
		-- Resize the focused client to the right
		awful.client.incwfact(-0.1)
	elseif key == "Escape" then
		-- Exit resize mode
		awful.keygrabber.stop()
	end
end

-- Key binding to enter resize mode
awful.keyboard.append_global_keybindings({
	awful.key({ modkey, }, "i", function()
			awful.keygrabber.run(resize_handler)
		end,
		{ description = "enter resize mode", group = "custom" })
})

