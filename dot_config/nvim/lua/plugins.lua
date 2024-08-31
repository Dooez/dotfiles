return {
    { -- dependencie managment
        "williamboman/mason.nvim",
        opts = {
            pip = {
                upgrade_pip = true,
            }
        }

    },
    'tpope/vim-sleuth', -- automatic indent detection
    {                   -- show pending keybinds
        'folke/which-key.nvim',
        event = "VeryLazy",
        opts = {}
    },
    { -- folds
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
                ensure_installed = {
                    'c', 'cpp', 'lua', 'doxygen', 'vim', 'vimdoc', 'markdown', 'markdown_inline', 'regex', 'bash',
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    -- additional_vim_regex_highlighting = false
                }
            })
        end
    },
    { -- statusline
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
    { --
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {
            focus = true,
            auto_close = true,
            modes = {
                lsp_references = {
                    title = false,
                    format = "{file_icon}{filename} {pos} {text:ts}",
                    groups = false,
                }
            },
            keys = {
                ["<cr>"] = "jump_close"
            }
        },
        keys = {
            -- {
            --     "gd",
            --     "<cmd>Trouble lsp_definitions focus=true auto_close=true<cr>",
            --     desc = "[G]o to [D]efinition"
            -- },
            -- {
            --     "gr",
            --     "<cmd>Trouble lsp_references focus=true auto_close=true<cr>",
            --     desc = "[G]o to [R]eferences"
            -- },
            {
                "<leader>q",
                "<cmd>Trouble diagnostics focus=true<cr>",
                desc = "Diagnostics"
            }
        }
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
    { -- additional navigtaion engine
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
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    'RRethy/vim-illuminate', -- highlight word under the cursor
    {                        -- scrolling animation
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
                    timing = qdtiming
                },
                scroll = {
                    timing = qdtiming
                },
                resize = { enable = false },
                open = { enable = false },
                close = { enable = false },
            })
        end,
    },
    {
        "danymat/neogen",
        config = true,
    },
    { -- context folds at the top of the buffer
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            mulitiline_threshold = 1,
        },
        config = true,
    },
    { -- filesystem explorer
        'stevearc/oil.nvim',
        -- Optional dependencies
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        -- keys = {
        --     {
        --         '<leader>e',
        --         '<cmd>Oil<cr>',
        --         desc = 'Open Oil',
        --     },
        -- },
        opts = {
            default_file_explorer = true,
            columns = {
                'icon',
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
            },
            keymap_help = {
                border = "square",
            },
            skip_confirm_on_simple_edits = true,
            lsp_file_methods = {
                autosave_changes = true,
            },
            experimental_watch_for_changes = true,
        },
        config = function(plugin, opts)
            require('oil').setup(opts)
            vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open Oil.' })
        end,

    },
    {
        "Grafcube/suedit.nvim",
        dependencies = "akinsho/toggleterm.nvim",
    },
    -- {
    --     "f-person/git-blame.nvim",
    --     -- event = "VeryLazy",
    --     opts = {
    --         message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    --         date_format = "%d-%m-%Y %H:%M:%S", -- template for the date, check Date format section for more options
    --         virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    --     },
    --     keypmas = {
    --         ["<leader>gb"] = "<CMD>GitBlameToggle<CR>",
    --     },
}
