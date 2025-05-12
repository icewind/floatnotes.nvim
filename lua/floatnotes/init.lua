local ui = require("floatnotes.ui")

---@alias PluginOptions
---|{
---   global_notes_file_path: string,
---   project_notes_names: ["todo.md", "notes.md"],
---   ui?: UIOptions,
---   win?: table<string, any>,
---   backdrop?: BackdropOptions,
--- }

local M = {}

---@param options PluginOptions
function M.setup(options)
    local default_options = {
        ui = {
            max_width = 120,
        },
        backdrop = {
            opacity = 30,
        },
        win = {
            border = vim.o.winborder or "none",
            zindex = 90, -- Telescope uses 100 by default
        },
    }
    
    options = vim.tbl_deep_extend("keep", options, default_options) --[[@as PluginOptions]]

    vim.api.nvim_create_user_command("FloatNotes", function()
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
