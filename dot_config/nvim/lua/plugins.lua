return {
    { -- dependencie managment
        "williamboman/mason.nvim",
        opts = {
            pip = {
                upgrade_pip = true,
            }
        }

    },
    {
        'echasnovski/mini.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        version = false,
        config = function()
            require 'mini.ai'.setup({})
            require 'mini.pairs'.setup({})
            local qdtiming = require 'mini.animate'.gen_timing.quadratic({
                duration = 150,
                unit = 'total',
            })
            require 'mini.animate'.setup({
                cursor = { timing = qdtiming },
                scroll = { timing = qdtiming },
                resize = { enable = false },
                open = { enable = false },
                close = { enable = false },
            })
        end,
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
                "<leader>Q",
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
        'numToStr/Comment.nvim',
        config = true,
    },
    {
        "kylechui/nvim-surround",
        enabled = true,
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

    -- visual
    { -- context folds at the top of the buffer
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            mulitiline_threshold = 1,
        },
        config = true,
    },
    { -- folds
        'kevinhwang1/nvim-ufo',
        dependencies = {
            'kevinhwang1/promise-async'
        },
        opts = {},
    },
    { 'RRethy/vim-illuminate' }, -- highlight word under the cursor
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
        'jedrzejboczar/nvim-dap-cortex-debug',
        dependencies = {
            'mfussenegger/nvim-dap'
        },
        config = function()
            require('dap-cortex-debug').setup {
                debug = false, -- log debug messages
                -- path to cortex-debug extension, supports vim.fn.glob
                -- by default tries to guess: mason.nvim or VSCode extensions
                extension_path = nil,
                lib_extension = nil, -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
                node_path = 'node',  -- path to node.js executable
                dapui_rtt = true,    -- register nvim-dap-ui RTT element
                -- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
                dap_vscode_filetypes = { 'c', 'cpp' },
            }
        end
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "amitds1997/remote-nvim.nvim",
        version = "*",                       -- Pin to GitHub releases
        dependencies = {
            "nvim-lua/plenary.nvim",         -- For standard functions
            "MunifTanjim/nui.nvim",          -- To build the plugin UI
            "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
        },
        config = true,
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        keys = {
            {
                "<C-w>p",
                mode = { "n", "x", "o" },
                function()
                    local win = require('window-picker').pick_window({ hint = 'floating-big-letter' });
                    if win then
                        vim.api.nvim_set_current_win(win)
                    end
                end,
                desc = "[P]ick window"
            },
        },
        config = function()
            require 'window-picker'.setup()
        end,
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = false,
        opts = {},
        keys = {
            {
                "<leader>rx",
                mode = { "x" },
                ":Refactor extract ",
                desc = "[R]efactor E[x]tract",
            },
            {
                "<leader>rxv",
                mode = { "x" },
                ":Refactor extract_var ",
                desc = "[R]efactor E[x]tract [V]ariable",
            },
            {
                "<leader>ri",
                mode = { "n", "x" },
                ":Refactor inline_func",
                desc = "[R]efactor [I]nline function",
            },
        },
    },
    {
        'isakbm/gitgraph.nvim',
        opts = {
            git_cmd = "git",
            symbols = {
                merge_commit = 'M',
                commit = '*',
            },
            format = {
                timestamp = '%H:%M %d-%m-%y',
                fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
            },
            hooks = {
                on_select_commit = function(commit)
                    print('selected commit:', commit.hash)
                end,
                on_select_range_commit = function(from, to)
                    print('selected range:', from.hash, to.hash)
                end,
            },
        },
        keys = {
            {
                "<leader>gL",
                function()
                    require('gitgraph').draw({}, { all = true, max_count = 5000 })
                end,
                desc = "GitGraph - Draw",
            },
        },
    },
}
