local ui = require("floatnotes.ui")
local utils = require("floatnotes.utils")

---@alias PluginOptions
---|{
---   global_notes_file_path: string,
---   project_notes_names: ["todo.md", "notes.md"],
---   ui?: UIOptions,
---   win?: table<string, any>,
---   backdrop?: BackdropOptions,
--- }

local M = {}

local default_options = {
	ui = {
		max_width = 120,
	},
	backdrop = {
		opacity = 30,
	},
	win = {
		border = vim.o.winborder,
	},
}

---@param options PluginOptions
function M.setup(options)
	options = vim.tbl_deep_extend("keep", options, default_options) --[[@as PluginOptions]]

	if not utils.file_exists(options.global_notes_file_path) then
		vim.notify(
			"Float Notes: Unable to read the notes file " .. options.global_notes_file_path,
			vim.log.levels.ERROR
		)
		return
	end

	vim.api.nvim_create_user_command("FN", function()
		ui.open_floating_notes({
			paths = {
				options.global_notes_file_path,
			},
			ui = options.ui,
			win = options.win,
			backdrop = options.backdrop,
		})
	end, {})
end

return M
