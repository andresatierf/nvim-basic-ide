local colorscheme = "onedark"

-- color variant for one dark
vim.g.onedark_config = {
	style = "warmer",
}

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end
