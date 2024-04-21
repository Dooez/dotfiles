return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'macchiato',
            custom_highlights = function(colors)
                local generic = colors.red
                local class = colors.blue
                local string = colors.yellow
                local fn = colors.green
                local const = colors.mauve
                local iface = colors.rosewater

                return {
                    Constant = { fg = const },
                    String = { fg = string },
                    Character = { fg = string },
                    Number = { fg = const },
                    Boolean = { fg = const },
                    Identifier = { fg = colors.text },
                    Function = { fg = fn },
                    Statement = { fg = generic },
                    Conditional = { link = "Statement" },
                    Repeat = { fg = generic },
                    Label = { link = "Statement" },
                    Operator = { fg = generic },
                    Keyword = { fg = generic },
                    Exception = { fg = generic },

                    PreProc = { fg = colors.red },
                    Include = { fg = colors.red },
                    Macro = { fg = colors.red, style = { 'bold' } },

                    StorageClass = { fg = generic },
                    Structure = { fg = colors.sapphire },
                    Special = { fg = generic },
                    Type = { fg = class },
                    ['@namespace'] = { fg = colors.text, style = {} },
                    ['@parameter'] = { fg = colors.peach, style = { 'italic' } },
                    ['@lsp.type.class'] = { fg = class },
                    ['@lsp.type.concept'] = { fg = iface },
                    ['@lsp.mod.readonly'] = { fg = const },
                    ['@lsp.typemod.method.readonly'] = { link = "@lsp.type.method" },
                    ['@lsp.typemod.parameter.readonly'] = { link = "@parameter" },
                    ['@function.builtin'] = { link = "Funciton" },
                    ['@type.builtin'] = { link = 'Type' },
                    ['@type.builtin.cpp'] = { link = 'Type' },
                    ['@attribute'] = { fg = colors.subtext0 },
                    ['@keyword.return'] = { link = 'Keyword' },
                    ['@keyword.operator'] = { link = 'Keyword' },
                    ['@keyword.doxygen'] = { fg = colors.subtext0 },
                }
            end,
            integrations = {
                indent_blankline = {
                    scope_color = 'surface2'
                },
            },

        })
        vim.cmd.colorscheme "catppuccin"
    end
}
