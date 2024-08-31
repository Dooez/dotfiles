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
        'Dooez/blame.nvim',
        dependencies = 'sindrets/diffview.nvim',
        keys = {
            {
                '<leader>gb',
                '<CMD>BlameToggle<CR>',
                desc = 'Show [G]it [B]lame',
            },
        },
        opts = {
            commit_detail_view = function(commit)
                vim.cmd('DiffviewOpen ' .. commit);
            end,
        }

    },
}
