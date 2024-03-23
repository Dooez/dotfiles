return {
    'mfussenegger/nvim-dap',
    dependencies = {
        -- Creates a beautiful debugger UI
        {
            'rcarriga/nvim-dap-ui',
            dependencies = {
                'nvim-neotest/nvim-nio'
            }
        },
        'williamboman/mason.nvim', -- Installs the debug adapters for you
        'jay-babu/mason-nvim-dap.nvim',
        'rcarriga/nvim-notify'

        --'leoluz/nvim-dap-go'
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        require('mason-nvim-dap').setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                'clangd',
                'codelldb',
                'clang-format'
            }
        }

        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<S-l>', dapui.eval, { desc = 'Debug: E[v]aluate expression in floating window' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint,
            { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, { desc = 'Debug: Set Breakpoint' })

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
            icons = {
                collapsed = "",
                current_frame = "→",
                expanded = ""
            },
            layouts = { {
                elements = {
                    { id = "breakpoints", size = 0.15 },
                    { id = "stacks",      size = 0.35 },
                    { id = "scopes",      size = 0.35 },
                    { id = "watches",     size = 0.15 },
                },
                position = "left",
                size = 40
            }, {
                elements = {
                    { id = "repl",    size = 0.3 },
                    { id = "console", size = 0.7 },
                },
                position = "bottom",
                size = 15
            } },
        })
        -- require("core.utils").load_mappings("dap")

        -- {
        --     -- Set icons to characters that are more likely to work in every terminal.
        --     --    Feel free to remove or use ones that you like more! :)
        --     --    Don't feel like these are good choices.
        --     icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        --     controls = {
        --         icons = {
        --             pause = '⏸',
        --             play = '▶',
        --             step_into = '⏎',
        --             step_over = '⏭',
        --             step_out = '⏮',
        --             step_back = 'b',
        --             run_last = '▶▶',
        --             terminate = '⏹',
        --             disconnect = '⏏'
        --         }
        --     }
        -- }

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set('n', '<F7>', dapui.toggle,
            { desc = 'Debug: See last session result.' })

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        dap.adapters.codelldb = {
            type = 'server',
            port = "13000",
            executable = {
                -- CHANGE THIS to your path!
                command = 'codelldb',
                args = { "--port", "13000" },

                -- On windows you may have to uncomment this:
                -- detached = false,
            }
        }
        dap.adapters.sudolldb = {
            type = 'server',
            port = "13000",
            executable = {
                -- CHANGE THIS to your path!
                command = '/home/timofey/sudo.lldb',
                args = { "--port", "13000" },

                -- On windows you may have to uncomment this:
                -- detached = false,
            }
        }
        dap.adapters.sudogdb = {
            type = 'executable',
            command = '/home/timofey/sudo.gdb',
            options = {
                env = {
                    ["DISPLAY"] = ":0",
                    ["XAUTHORITY"] = "/run/user/1000/gdm/Xauthority",
                },
            }
        }
        dap.adapters.lldb = dap.adapters.codelldb
        local get_cmake_target = function()
            local cmake_found, cmake = pcall(require, 'cmake-tools')
            if not cmake_found then
                require('notify')('CMake not found.', vim.log.levels.ERROR, { title = 'Launching CMake target debug' })
                return dap.ABORT
            end
            local target = cmake.get_launch_target()
            local err = cmake.build({ target = target }, cmake.close_executor)
            if err == nil then
                return cmake.get_build_directory() .. '/' .. cmake.get_launch_target()
            else
                require('notify')('CMake build error.', vim.log.levels.ERROR, { title = 'Launching CMake target debug' })
                return dap.ABORT
            end
        end
        dap.configurations.cpp = {
            {
                name = "lldb=>CMake Target",
                type = "codelldb",
                request = "launch",
                program = get_cmake_target,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
            {
                name = "root=>lldb=>CMake Target",
                type = "sudolldb",
                request = "launch",
                program = get_cmake_target,
                cwd = '${workspaceFolder}',
                env = { ['DISPLAY'] = '${env:DISPLAY}', ['XAUTHORITY'] = '${env:XAUTHORITY}' },
                sourceLanguages = { "cpp" },
                stopOnEntry = false,
            },
        }
        local sign = vim.fn.sign_define

        sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
        sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    end
}
