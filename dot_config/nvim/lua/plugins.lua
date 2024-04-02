return {
    -- Git related plugins
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    {
        'sindrets/diffview.nvim',
        config = function()
            require('diffview').setup({
                file_panel = {
                    listing_style = 'list',
                    win_config = {
                        position = 'bottom',
                        height = 16,
                    },
                }
            })

            vim.keymap.set('n', '<leader>gd', function() vim.cmd('DiffviewOpen') end,
                { desc = 'Open [G]it [D]iff panel.' })
            vim.keymap.set('n', '<leader>gh', function() vim.cmd('DiffviewFileHistory') end,
                { desc = 'Open [G]it [H]istroy panel.' })
            vim.keymap.set('n', '<leader>gc', function() vim.cmd('DiffviewClose') end, { desc = '[G]it panel [C]lose.' })
        end
    },
    { 'numToStr/Comment.nvim', opts = {} },
    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',  opts = {} },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        opts = {},
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'c', 'cpp', 'lua', 'doxygen' },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                }
            })
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set('n', '<leader>e', api.tree.toggle, { desc = 'Toggle file panel' })
                vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            end

            -- pass to setup along with your other options
            require("nvim-tree").setup {
                on_attach = my_on_attach,
                renderer = {
                    highlight_modified = 'icon',
                    icons = {
                        git_placement = 'after',
                        modified_placement = 'before',
                    },
                },
                modified = {
                    enable = true,
                },
                view = {
                    preserve_window_proportions = true,
                }
            }
        end,
    },
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        after = 'catppuccin',
        config = function()
            require('bufferline').setup({
                options = {
                    mode = 'tabs',
                    style_preset = require('bufferline').style_preset.minimal,
                    always_show_bufferline = false,
                },
                highlights = require("catppuccin.groups.integrations.bufferline").get()
            })
        end
    },
    {
        "folke/trouble.nvim",
        --branch = 'dev',

        --opts = {
        --group = false,
        --},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = '┆',
            },
            scope = {
                char = '║',
                show_start = false,
                show_end = false,
            },

        }
    },
    -- {
    --     'psliwka/vim-smoothie',
    -- },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require 'nvim-autopairs'.setup({
                enable_check_bracket_line = false,
            })
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
    'RRethy/vim-illuminate',
    {
        'echasnovski/mini.animate',
        version = false,
        config = function()
            local animate = require('mini.animate')
            local qdtiming = require('mini.animate').gen_timing.quadratic(
                {
                    duration = 150,
                    unit = 'total',
                }
            )

            animate.setup({
                cursor = {
                    timing = require('mini.animate').gen_timing.quadratic(
                        {
                            duration = 75,
                            unit = 'total',
                        }
                    )
                },
                scroll = {
                    timing = qdtiming
                }

            })
        end,
    },
    {
        "danymat/neogen",
        config = true,
    },
}
