return {
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'p00f/clangd_extensions.nvim',
            'folke/neodev.nvim',
            { -- Useful status updates for LSP
                'j-hui/fidget.nvim',
                opts = {}
            },
            { -- Autocompletion
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
            'folke/trouble.nvim'
        },
        config = function()
            local servers

            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            --
            --  If you want to override the default filetypes that your language server will attach to you can
            --  define the property 'filetypes' to the map in question.
            servers = {
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
            require('mason-lspconfig').setup {
                ensure_installed = vim.tbl_keys(servers),
            }
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

            -- Floating window for renaming
            local rename_win
            local rename_open = false
            vim.api.nvim_create_augroup('CloseRenameBuf', { clear = true })
            vim.api.nvim_create_autocmd('BufLeave', {
                group = 'CloseRenameBuf',
                callback = function()
                    local filetype = vim.api.nvim_get_option_value(
                        'filetype',
                        {
                            buf = vim.api.nvim_get_current_buf()
                        }
                    )
                    if filetype == 'rename' then
                        vim.api.nvim_win_close(rename_win, true)
                        rename_open = false
                    end
                end
            })

            local function rename()
                local pos = vim.api.nvim_win_get_cursor(0)
                local cword = vim.fn.expand('<cword>')
                local opts = {
                    relative = 'cursor',
                    row = 0,
                    col = 0,
                    width = 30,
                    height = 1,
                    style = 'minimal',
                    border = 'single',
                    title = '[rename]',
                    title_pos = 'right',
                }
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_set_option_value(
                    'filetype',
                    'rename',
                    { buf = buf }
                )

                if rename_open then
                    vim.api.nvim_win_close(rename_win, true)
                end
                rename_win = vim.api.nvim_open_win(buf, true, opts)
                rename_open = true

                local abort = function()
                    vim.api.nvim_win_close(rename_win, true)
                    vim.cmd('stopinsert')
                end

                local function dorename()
                    local new_name = vim.trim(vim.fn.getline('.'))
                    vim.api.nvim_win_close(rename_win, true)
                    vim.api.nvim_win_set_cursor(0, pos)
                    vim.lsp.buf.rename(new_name)
                    vim.cmd('stopinsert')
                end

                vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
                vim.keymap.set({ 'n', 'v' }, '<C-c>', abort, { silent = true, buffer = buf })
                vim.keymap.set({ 'n', 'v' }, '<Esc>', abort, { silent = true, buffer = buf })
                vim.keymap.set({ 'n', 'v' }, '<CR>', dorename, { silent = true, buffer = buf })
                vim.keymap.set({ 'i' }, '<CR>',
                    function()
                        pos[2] = pos[2] + 1 -- workaround for cursor moving 1 position after exitint exit mode
                        dorename()
                    end,
                    { silent = true, buffer = buf })
            end

            -- [[ Configure LSP ]]
            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(client, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                nmap('<leader>rn', rename, '[R]e[n]ame')
                --nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', '<cmd>Trouble lsp_definitions<cr>', '[G]oto [D]efinition')
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                nmap('gr', '<cmd>Trouble lsp_references<cr>', '[G]oto [R]eferences')
                nmap('gI', '<cmd>Trouble lsp_implementations<cr>', '[G]oto [I]mplementation')

                -- nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                nmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch [S]ymbols')
                nmap('<leader>sw', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    '[S]earch [W]orkspace Symbols')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')


                -- language specific
                local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
                if filetype == 'cpp' or filetype == 'c' then
                    nmap('<M-o>', '<CMD>ClangdSwitchSourceHeader<CR>', 'Switch to header/source.')
                end
            end

            require('mason-lspconfig').setup_handlers {
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
            local ls = require 'luasnip'
            require('luasnip.loaders.from_vscode').lazy_load()
            ls.config.setup {}
            local s = ls.snippet
            -- local sn = ls.snippet_node
            -- local t = ls.text_node
            local i = ls.insert_node
            -- local f = ls.function_node
            -- local c = ls.choice_node
            -- local d = ls.dynamic_node
            -- local r = ls.restore_node
            local fmt = require("luasnip.extras.fmt").fmt
            -- local rep = require("luasnip.extras").rep
            ls.add_snippets("all", {
                s("rangesnip",
                    fmt(
                        [=[
                    using value_type = {1};
                    using reference = value_type&;
                    using const_reference = const value_type&;
                    using size_type       = uZ;
                    using difference_type = std::ptrdiff_t;
                    using pointer         = value_type*;
                    using const_pointer   = const value_type*;
                    using iterator        = pointer;
                    using const_iterator  = const_pointer;

                    [[nodiscard]] auto data() noexcept -> pointer {{return m_data_ptr;}}
                    [[nodiscard]] auto data() const noexcept -> const_pointer {{return m_data_ptr;}}
                    [[nodiscard]] auto size() const noexcept -> size_type {{return m_size;}}
                    [[nodiscard]] auto length() const noexcept -> size_type {{return size();}}

                    [[nodiscard]] auto begin() noexcept -> iterator {{return data();}}
                    [[nodiscard]] auto cbegin() const noexcept -> const_iterator {{return data();}}
                    [[nodiscard]] auto begin() const noexcept -> const_iterator {{treturn data();}}
                    [[nodiscard]] auto end() noexcept -> iterator {{return data() + size();}}
                    [[nodiscard]] auto cend() const noexcept -> const_iterator {{return data() + size();}}
                    [[nodiscard]] auto end() const noexcept -> const_iterator {{return cend();}}

                    [[nodiscard]] auto operator[](size_type pos) noexcept -> reference {{return *(data() + pos);}}
                    [[nodiscard]] auto operator[](size_type pos) const noexcept -> const_reference {{return *(data() + pos);}}
                    [[nodiscard]] auto at(size_type pos) noexcept -> reference {{
                    if (pos >= size()) throw std::out_of_range("pos >= size()");
                    return *(data() + pos);
                    }}
                    ]=],
                        {
                            i(1, "T"),
                        }
                    )
                ),
            })

            cmp.setup {
                snippet = {
                    expand = function(args)
                        ls.lsp_expand(args.body)
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
                        elseif ls.expand_or_locally_jumpable() then
                            ls.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif ls.locally_jumpable(-1) then
                            ls.jump(-1)
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

    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        enabled = true,
        opts = {
            hint_enable = false,
            floating_window_above_cur_line = true,
            padding = ' ',
            handler_opts = {
                border = "none",
            },

        },
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    }
}
