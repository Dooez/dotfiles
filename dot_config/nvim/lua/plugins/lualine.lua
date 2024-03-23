return {
   {
      'nvim-lualine/lualine.nvim',
      dependencies = {
         'nvim-tree/nvim-web-devicons',
         "SmiteshP/nvim-navic",
      },
      config = function()
         local lualine = require('lualine')
         local conditions = {
            buffer_not_empty = function()
               return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
            end,
            hide_in_width = function()
               return vim.fn.winwidth(0) > 80
            end,
            check_git_workspace = function()
               local filepath = vim.fn.expand('%:p:h')
               local gitdir = vim.fn.finddir('.git', filepath .. ';')
               return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
         }
         local navic = require('nvim-navic')
         local config = {
            options = {
               component_separators = '',
               section_separators = '',
               theme = 'catppuccin',
               disabled_filetypes = { 'NvimTree' },
            },
            sections = {
               -- these are to remove the defaults
               lualine_a = {
                  'mode',
               },
               lualine_b = {
                  {
                     'diagnostics',
                     sources = { 'nvim_diagnostic', 'nvim_lsp' },
                     sections = { 'error', 'warn', 'info', 'hint' },
                  }
               },
               lualine_c = {
                  {
                     'filetype',
                     icon_only = true,
                     padding = { left = 1, right = 0 },
                  },
                  {
                     'filename',
                     separator = '',
                     icons_enabled = true,
                     cond = function()
                        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
                     end
                  },
                  {
                     function()
                        return navic.get_location()
                     end,
                     cond = function()
                        return navic.is_available()
                     end
                  }
               },
               lualine_x = {
               },
               lualine_y = { 'progress' },
               lualine_z = {},
               -- -- These will be filled later
            },
            -- inactive_sections = {
            --    -- these are to remove the defaults
            --    lualine_a = {},
            --    lualine_b = {},
            --    lualine_y = {},
            --    lualine_z = {},
            --    lualine_c = {},
            --    lualine_x = {},
            -- },
         }
         lualine.setup(config)
      end
   }
}
