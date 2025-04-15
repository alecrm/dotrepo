return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    start_in_insert = true,
    size = 20,
    open_mapping = [[<leader>tt]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    direction = "horizontal", -- 'vertical' | 'float' | 'tab'
    close_on_exit = true,
    shell = vim.o.shell,      -- use default shell
  },
  cmd = { "ToggleTerm" },
  config = function()
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "term://*",
      callback = function()
        -- Defer a bit to allow windows.nvim to finish its adjustments
        vim.defer_fn(function()
          -- Force terminal to enter insert mode
          vim.cmd("startinsert!")
        end, 50)  -- adjust the delay as needed (in milliseconds)
      end,
    })


    local Terminal = require("toggleterm.terminal").Terminal

    local function get_activation_command()
      -- Use the tracked variable or set a default path if not present.
      local venv_path = vim.b.venv_path or "./venv/bin/activate"
      local file = io.open(venv_path, "r")
      if file then
        file:close()
        return "source " .. venv_path .. " && exec $SHELL"
      else
        return "$SHELL"  -- Fallback if the activation script doesn't exist
      end
    end

    -- Define custom floating lazygit terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      float_opts = {
        border = "double",
      },
    })

    local htop = Terminal:new({
      cmd = "htop",
      hidden = true,
      direction = "float",
      float_opts = {
        border = "double"
      },
    })

    vim.keymap.set("t", "<Esc>", function()
      -- Exit terminal mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)

      -- Check if the current window is floating
      local win_config = vim.api.nvim_win_get_config(0)
      if win_config.relative == "" then  -- not a floating window
        -- Check if current buffer is a ToggleTerm terminal, then close the window
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("term://") then
          vim.cmd("close")
        end
      end
    end, { noremap = true, silent = true })

    -- Global keymap to toggle lazygit
    vim.keymap.set("n", "<leader>gg", function()
      lazygit:toggle()
    end, { desc = "Toggle LazyGit" })

    vim.keymap.set("n", "<leader>th", function()
      htop:toggle()
    end, { desc = "Toggle htop"})

    -- Example: Python REPL terminal
    local python = Terminal:new({
      cmd = "python",
      hidden = true,
      direction = "horizontal",
    })

    vim.keymap.set("n", "<leader>tp", function()
      python:toggle()
    end, { desc = "Toggle Python REPL" })

    vim.keymap.set("n", "<C-\\>", function()
      local cmd = get_activation_command()
      -- Create a temporary terminal instance with the dynamically generated cmd.
      local term = Terminal:new({
        cmd = cmd,
        direction = "horizontal",
        hidden = true,
      })
      term:toggle() 
    end, { desc = "Toggle venv-aware terminal" })

    vim.keymap.set("n", "<leader>tf", function()
      local cmd = get_activation_command()
      local term = Terminal:new({
        cmd = cmd,
        direction = "float",
        hidden = true,
      })
      term:toggle()
    end, { desc = "Toggle Floating Terminal" })
  end,

  keys = {
    {
      "<leader>tv",
      function()
        require("toggleterm.terminal").Terminal
            :new({ direction = "vertical" })
            :toggle()
      end,
      desc = "Toggle Vertical Terminal",
    },
  },
}
