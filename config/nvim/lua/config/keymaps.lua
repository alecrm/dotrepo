vim.keymap.set("n", "<leader>q", function()
  -- Go to dashboard + manually trigger drop
  local function go_to_dashboard()
    vim.cmd("Alpha")
    vim.defer_fn(function()
      local ok, drop = pcall(require, "config.drop")
      if ok then drop.setup() end
    end, 50)
  end

  -- If not modified, quick quit
  if not vim.bo.modified then
    vim.cmd("bdelete")
    vim.schedule(go_to_dashboard)
    return
  end

  -- Prompt for save/quit decision
  vim.cmd("redraw")
  vim.api.nvim_echo(
    { { "[q] quit w/o saving, [x] save + quit, [c] cancel", "WarningMsg" } },
    false,
    {}
  )
  local key = vim.fn.nr2char(vim.fn.getchar())

  if key == "q" then
    vim.cmd("bdelete!")
    go_to_dashboard()
  elseif key == "x" then
    vim.cmd("write | bdelete")
    go_to_dashboard()
  else
    vim.api.nvim_echo({ { "Cancelled", "Normal" } }, false, {})
  end
end, { desc = "Smart quit to dashboard with drop" })



vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Show diagnostic" })

vim.keymap.set("n", "<leader>vl", "<cmd>Telescope diagnostics<CR>", { desc = "List diagnostics" })

vim.keymap.set("n", "<leader>fp", function()
  require("telescope").extensions.projects.projects()
end, { desc = "Find Projects" })

-- Visual mode tab to indent, and stay in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Line Swapping keymaps
-- Normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
