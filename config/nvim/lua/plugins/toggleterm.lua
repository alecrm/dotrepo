return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
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
    local Terminal = require("toggleterm.terminal").Terminal

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

    -- Easy escape from terminal mode with Esc
    vim.keymap.set("t", "<Esc>", function()
      -- Exit terminal mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)

      -- Check if current buffer is a ToggleTerm terminal
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname:match("term://") then
        vim.cmd("close") -- closes the window
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
  end,

  keys = {
    -- Optional hotkey to toggle float specifically
    {
      "<C-\\>",
      function()
        require("toggleterm.terminal").Terminal
            :new({ direction = "horizontal" })
            :toggle()
      end,
      desc = "Toggle Vertical Terminal",
    },
    {
      "<leader>tf",
      function()
        require("toggleterm.terminal").Terminal
            :new({ direction = "float" })
            :toggle()
      end,
      desc = "Toggle Floating Terminal",
    },
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
