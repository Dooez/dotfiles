return {
    'stevearc/conform.nvim',
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            cpp = { "clang_format" }
        }
    },
    -- 'mhartington/formatter.nvim',
    -- config = function(plugin, opts) -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    --     local util = require "formatter.util"
    --     require('formatter').setup {
    --         -- Enable or disable logging
    --         logging = true,
    --         -- Set the log level
    --         log_level = vim.log.levels.WARN,
    --         -- All formatter configurations are opt-in
    --         filetype = {
    --             -- Formatter configurations for filetype "lua" go here
    --             -- and will be executed in order
    --             lua = {
    --                 -- "formatter.filetypes.lua" defines default configurations for the
    --                 -- "lua" filetype
    --                 -- require("formatter.filetypes.lua").stylua,
    --                 -- You can also define your own configuration
    --                 function()
    --                     -- Supports conditional formatting
    --                     if util.get_current_buffer_file_name() == "special.lua" then
    --                         return nil
    --                     end
    --
    --                     -- Full specification of configurations is down below and in Vim help
    --                     -- files
    --                     return {
    --                         exe = "lua-format",
    --                         args = {
    --                             "--align-table-field",
    --                             "--chop-down-table",
    --                             " --no-keep-simple-control-block-one-line"
    --                         },
    --                         stdin = true
    --                     }
    --                 end
    --             },
    --
    --             -- Use the special "*" filetype for defining formatter configurations on
    --             -- any filetype
    --             ["*"] = {
    --                 -- "formatter.filetypes.any" defines default configurations for any
    --                 -- filetype
    --                 require("formatter.filetypes.any").remove_trailing_whitespace
    --             }
    --         }
    --     }
    -- end
}
