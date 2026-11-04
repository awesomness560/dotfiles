local get_hovered = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url) or nil
end)

return {
	entry = function()
		local url = get_hovered()
		if not url then
			return
		end

		-- Run 'du -sh' in the background on the hovered item
		local output = Command("du"):arg("-sh"):arg(url):output()

		if output and output.stdout then
			-- Extract just the size (e.g., "4.2G") from the stdout text
			local size = output.stdout:match("^(%S+)")
			if size then
				ya.notify({
					title = "Hovered Size",
					content = size .. " - " .. url:match("([^/]+)$"),
					timeout = 3.0,
					level = "info",
				})
			end
		end
	end,
}
