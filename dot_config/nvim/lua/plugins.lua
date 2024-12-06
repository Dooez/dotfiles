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
    { -- save files as sudo
        "Grafcube/suedit.nvim",
        dependencies = "akinsho/toggleterm.nvim",
    },


    -- special buffers
    { -- tabs line
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
            {
                "<leader>q",
                "<cmd>Trouble diagnostics focus=true<cr>",
                desc = "Diagnostics"
            }
        }
    },
    { -- filesystem explorer
        'stevearc/oil.nvim',
        -- Optional dependencies
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
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


    -- editing and navigtaion
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
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    { -- docs generation
        "danymat/neogen",
        event = "VeryLazy",
        config = true,
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
    { 'numToStr/Comment.nvim', opts = {} },


    -- visual
    { -- context folds at the top of the buffer
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            mulitiline_threshold = 1,
        },
        config = true,
    },
    { -- folds
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        opts = {},
    },

    'RRethy/vim-illuminate', -- highlight word under the cursor
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
    { -- scrolling animation
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
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'hrsh7th/nvim-cmp',
            'nvim-telescope/telescope.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/vaults/personal",
                },
                -- {
                --     name = "work",
                --     path = "~/vaults/work",
                -- },
            },
        },
    },
}
