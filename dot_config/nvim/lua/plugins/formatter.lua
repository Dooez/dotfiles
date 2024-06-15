return {
    {
        "stevearc/conform.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            formatters_by_ft = {
                cpp = { "clang_format" },
                python = { "isort", "black" },
                cmake = { "cmakelang" },
            },
        },
        -- keys = {
        --     {
        --         'leader<f>',
        --         function() require('conform').format({ lsp_fallback = true }) end,
        --         desc = "[F]ormat current buffer",
        --     }
        -- },
        config = function(plugin, opts)
            require('conform').setup(opts)
            vim.keymap.set('n', '<leader>f', function() require('conform').format({ lsp_fallback = true }) end,
                { desc = "[F]ormat current buffer." })
        end

    },
    {
        "zapling/mason-conform.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "stevearc/conform.nvim",
        },
        config = function()
            require("mason-conform").setup()
        end,
    },
}
