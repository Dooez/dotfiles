return {
    'tpope/vim-fugitive', -- git commands
    {                     -- git diffview
        'sindrets/diffview.nvim',
        opts = {
            file_panel = {
                listing_style = 'list',
                win_config = {
                    position = 'bottom',
                    height = 16,
                },
            },
        },
        keys = {
            {
                '<leader>gd',
                '<cmd>DiffviewOpen<cr>',
                desc = 'Open [G]it [D]iff panel.',
            },
            {
                '<leader>gh',
                '<cmd>DiffviewFileHistory --reflog<cr>',
                desc = 'Open [G]it [H]istroy panel.',
            },
            {
                '<leader>gq',
                '<cmd>DiffviewClose<cr>',
                desc = '[G]it panel [Q]uit.',
            },
        }
    },
    {
        'FabijanZulj/blame.nvim',
        dependencies = 'sindrets/diffview.nvim',
        keys = {
            {
                '<leader>gb',
                '<CMD>BlameToggle<CR>',
                desc = 'Show [G]it [B]lame',
            },
        },
        opts = {
            commit_detail_view = function(commit, row, path)
                vim.cmd('DiffviewOpen ' .. commit .. ' --selected-file=' .. path);
            end,
        }

    },
    {
        "harrisoncramer/gitlab.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            -- "stevearc/dressing.nvim",                                -- Recommended but not required. Better UI for pickers.
            "nvim-tree/nvim-web-devicons",                           -- Recommended but not required. Icons in discussion tree.
        },
        build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
        config = function()
            require("gitlab").setup()
        end,
    }
}
