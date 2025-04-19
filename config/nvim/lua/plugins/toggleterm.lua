-- Helper functions
local function get_root()
  -- start from cwd (or use vim.api.nvim_buf_get_name(0) to use current file)
  local cwd = vim.loop.cwd()
  -- look for any of these files in parent directories
  local markers = { "pyproject.toml", "requirements.txt", ".git" }
  local found  = vim.fs.find(markers, { upward = true, path = cwd })[1]
  return found and vim.fs.dirname(found) or cwd
end

local function get_activation_command()
  local root     = get_root()
  local activate = root .. "/.venv/bin/activate"
  if vim.fn.filereadable(activate) == 1 then
    return "source " .. activate .. " && exec $SHELL"
  end
  return vim.o.shell
end

-- Plugin declaration
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    start_in_insert = true,
    size = 20,
    open_mapping = [[<leader>tn]],
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
    on_open = function(term)
      local cmd = get_activation_command()
      term:send(cmd, true)
    end,
  },
  cmd = { "ToggleTerm" },
  config = function()
    -- Makes sure we always end up in insert mode
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


    -- Local variable declarations
    local Terminal = require("toggleterm.terminal").Terminal -- Terminal to use
    local terms_by_root = {} -- Table for tracking terminals per project


    -- Keymap to allow closing non-floating terminals via Esc
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


    -- Function for toggling venv-aware terminals
    local function toggle_venv_term(direction)
      local root = get_root()
      local cmd  = get_activation_command()

      -- ensure we have a sub‑table for this project
      terms_by_root[root] = terms_by_root[root] or {}

      -- reuse or create the Terminal for this root+direction
      if not terms_by_root[root][direction] then
        terms_by_root[root][direction] = Terminal:new({
          cmd       = cmd,
          direction = direction,
          hidden    = true,
        })
      end

      -- show or hide it
      terms_by_root[root][direction]:toggle()
    end


    -- Custom terminal tools
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

    local python = Terminal:new({
      cmd = "python",
      hidden = true,
      direction = "horizontal",
    })


    -- Global toggles
    -- lazygit
    vim.keymap.set("n", "<leader>gg", function()
      lazygit:toggle()
    end, { desc = "Toggle LazyGit" })

    -- htop
    vim.keymap.set("n", "<leader>th", function()
      htop:toggle()
    end, { desc = "Toggle htop"})

    -- python
    vim.keymap.set("n", "<leader>tp", function()
      python:toggle()
    end, { desc = "Toggle Python REPL" })

    -- Floating venv term
    vim.keymap.set({ "n", "t" }, "<C-\\>", function()
        toggle_venv_term("float")
    end, { desc = "Toggle horizontal venv term" })

    -- Vertical venv term
    vim.keymap.set("n", "<leader>tv", function()
      toggle_venv_term("vertical")
    end, { desc = "Toggle vertical venv term" })

    -- Horizontal venv term
    vim.keymap.set("n", "<leader>to", function()
      toggle_venv_term("horizontal")
    end, { desc = "Toggle floating venv term" })
  end,
}
