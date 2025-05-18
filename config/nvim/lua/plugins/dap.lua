local function get_python_path()
  local cwd = vim.fn.getcwd()

  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return "python3" -- fallback
  end
end


return {

  -- mason-nvim-dap
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "debugpy" },
      automatic_setup = true,
    },
    event = "VeryLazy",
  },

  -- nvim-dap
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      vim.keymap.set("n", "<leader>dp", function() require("dap").pause() end, { desc = "DAP: Pause debug" })
      vim.keymap.set("n", "<leader>dy", function() dap.continue() end, { desc = "DAP: Continue debug" })
      vim.keymap.set("n", "<leader>dr", function() dap.step_over() end, { desc = "DAP: Step over next function" })
      vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "DAP: Step into current function" })
      vim.keymap.set("n", "<leader>dt", function() dap.step_out() end, { desc = "DAP: Step out of current function" })
      vim.keymap.set("n", "<Leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP: Add breakpoint" })
      vim.keymap.set("n", "<Leader>dk", function()
        local dap = require("dap")
        if dap.session() then
          dap.terminate()  -- this triggers the dapui listeners
        else
          vim.notify("No active debug session", vim.log.levels.WARN)
        end
      end, { desc = "DAP: Kill debug session" })
    end,
    event = "VeryLazy",
  },

  -- nvim-dap-ui
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    opts = {},
    config = function(_, opts)
      local dapui = require("dapui")
      local dap = require("dap")

      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
    event = "VeryLazy",
  },

  -- nvim-dap-python
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup(
        get_python_path(),
        {
          test_runner = "pytest",
          test_args = { "--run-type=local" }
        }
      )

      for _, funcName in ipairs({ "test_method", "test_class", "debug_selection" }) do
        local origFunc = dap_python[funcName]
        dap_python[funcName] = function(opts)
          opts = opts or {}
          opts.config = vim.tbl_extend("force", opts.config or {}, {
            justMyCode = true,
            -- Optionally, add rules to skip certain modules:
            rules = { { module = "atm", include = true } },  -- skip pytest frames
          })
          origFunc(opts)
        end
      end

      vim.keymap.set("n", "<Leader>dm", function() dap_python.test_method() end, { desc = "DAP Python: Test Method" })
      vim.keymap.set("n", "<Leader>dc", function() dap_python.test_class() end, { desc = "DAP Python: Test Class" })
      vim.keymap.set("n", "<Leader>df", function() dap_python.debug_selection() end, { desc = "DAP Python: Debug Selection" })

      vim.keymap.set("n", "<Leader>dM", function()
        local args = vim.fn.input("Pytest args: ")
        local split_args = vim.split(args, " ")
        dap_python.test_args = split_args
        dap_python.test_method()
      end, { desc = "DAP Python: Test Method With Args" })

      vim.keymap.set("n", "<Leader>dC", function()
        local args = vim.fn.input("Pytest args: ")
        local split_args = vim.split(args, " ")
        dap_python.test_args = split_args
        dap_python.test_class()
      end, { desc = "DAP Python: Test Class With Args" })

      vim.keymap.set("n", "<Leader>dF", function()
        local args = vim.fn.input("Pytest args: ")
        local split_args = vim.split(args, " ")
        dap_python.test_args = split_args
        dap_python.debug_selection()
      end, { desc = "DAP Python: Debug selection With Args" })

      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          -- require("dap-python").setup(
          dap_python.setup(
            get_python_path(),
            {
              test_runner = "pytest",
              test_args = { "--run-type=local" },
            }
          )
        end,
      })
    end,
    ft = "python",
  },
}

