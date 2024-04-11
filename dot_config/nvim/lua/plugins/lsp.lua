return {
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', opts = {} },
            'williamboman/mason-lspconfig.nvim',
            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
            {
                -- Autocompletion
                'hrsh7th/nvim-cmp',
                dependencies = {
                    -- Snippet Engine & its associated nvim-cmp source
                    'L3MON4D3/LuaSnip',
                    'saadparwaiz1/cmp_luasnip',
                    -- Adds LSP completion capabilities
                    'hrsh7th/cmp-nvim-lsp',
                    -- Adds a number of user-friendly snippets
                    'rafamadriz/friendly-snippets'
                }
            },
            'nvim-telescope/telescope.nvim',
            {
                "Dooez/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim"
                },
                opts = {
                    lsp = { auto_attach = true },
                    custom_hl_group = "Visual"
                }
            },
            {
                'p00f/clangd_extensions.nvim',
            }
        },
        config = function()
            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            --
            --  If you want to override the default filetypes that your language server will attach to you can
            --  define the property 'filetypes' to the map in question.
            local servers = {
                clangd = {},
                -- gopls = {},
                pyright = {},
                -- rust_analyzer = {},
                -- tsserver = {},
                -- html = { filetypes = { 'html', 'twig', 'hbs'} },
                neocmake = {},
                matlab_ls = {},
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            }
            -- Ensure the servers above are installed
            local mason_lspconfig = require 'mason-lspconfig'

            mason_lspconfig.setup {
                ensure_installed = vim.tbl_keys(servers),
            }


            -- local lspconfig = require('lspconfig')
            -- lspconfig.clangd.setup{
            --     settings = {
            --         cmd = '/usr/bin/clangd'
            --     }
            -- }

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }

            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
            -- [[ Configure LSP ]]
            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(client, bufnr)
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                --nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                --nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch [S]ymbols')
                nmap('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    '[S]earch [W]orkspace Symbols')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                -- Lesser used LSP functionality
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                --nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                --nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                --nmap('<leader>wl', function()
                --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                --end, '[W]orkspace [L]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
                -- require('folding').on_attach()

                local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                if filetype == 'cpp' or filetype == 'c' then
                    nmap('<M-o>', '<CMD>ClangdSwitchSourceHeader<CR>','Switch to header/source.' )
                end
                require("nvim-navbuddy").attach(client, bufnr)
            end

            mason_lspconfig.setup_handlers {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    }
                end,
            }

            -- [[ Configure nvim-cmp ]]
            -- See `:help cmp`
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            require('luasnip.loaders.from_vscode').lazy_load()
            luasnip.config.setup {}

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.recently_used,
                        require("clangd_extensions.cmp_scores"),
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    }
                }
            }
        end

    }
}
