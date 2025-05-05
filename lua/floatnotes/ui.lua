local UI = {}

---@alias BackdropOptions { color?: string, opacity?: number }
---@alias UIOptions { max_width?: number }

---@param buf number
---@param options BackdropOptions
local function create_backdrop(buf, options)
	local hlGroup = "FloatNotesNormal"
	local backdropBuffer = vim.api.nvim_create_buf(false, true)
	vim.bo[backdropBuffer].buftype = "nofile"

	local backdropWindow = vim.api.nvim_open_win(backdropBuffer, false, {
		relative = "editor",
		border = "none",
		row = 0,
		col = 0,
		width = vim.o.columns,
		height = vim.o.lines,
		focusable = false,
		style = "minimal",
		zindex = 99,
	})

	vim.api.nvim_create_autocmd({ "WinClosed", "BufLeave" }, {
		once = true,
		buffer = buf,
		callback = function()
			if vim.api.nvim_win_is_valid(backdropWindow) then
				vim.api.nvim_win_close(backdropWindow, true)
			end
			if vim.api.nvim_buf_is_valid(backdropBuffer) then
				vim.api.nvim_buf_delete(backdropBuffer, { force = true })
			end
		end,
	})

	vim.api.nvim_set_hl(0, hlGroup, { link = "Normal" }) -- Use the same color to make content dimmed
	if options.color then
		vim.api.nvim_set_hl(0, hlGroup, { bg = options.color })
	end
	vim.wo[backdropWindow].winhighlight = "Normal:" .. hlGroup
	vim.wo[backdropWindow].winblend = options.opacity
end

local function create_window(buf, options)
	local vim_ui = vim.api.nvim_list_uis()[1]
	local width = math.min(math.floor(vim_ui.width * 0.8), options.ui.max_width)
	local height = math.floor(vim_ui.height * 0.8)
	local window_options = vim.tbl_extend("keep", options.win or {}, {
		relative = "editor",
		width = width,
		height = height,
		col = (vim_ui.width - width) / 2,
		row = (vim_ui.height - height) / 2,
		anchor = "NW",
		zindex = 100,
	})

	create_backdrop(buf, options.backdrop)

	local win = vim.api.nvim_open_win(buf, true, window_options)
	-- Disable separate hl groups
	vim.wo[win].winhl = "Normal:FN_Normal,FloatBorder:FN_FloatBorder"

	return win
end

local function create_buffer(filepath)
	local buf = vim.fn.bufnr(filepath, true)

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(0, true)
	end, { buffer = buf })

	vim.bo[buf].swapfile = false
	return buf
end

---@param options {paths: string[], ui: table}
function UI.open_floating_notes(options)
	local filepath = options.paths[1]

	local buf = create_buffer(filepath)
	create_window(buf, options)
end

return UI
