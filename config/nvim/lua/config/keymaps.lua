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

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Show diagnostic" })

vim.keymap.set("n", "<leader>vl", "<cmd>Telescope diagnostics<CR>", { desc = "List diagnostics" })

vim.keymap.set("n", "<leader>fp", function()
  require("telescope").extensions.projects.projects()
end, { desc = "Find Projects" })

-- Visual mode tab to indent, and stay in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

vim.keymap.set("i", "<C-d>", "<C-o>x", { desc = "Forward delete (simulate 'x')" })
vim.keymap.set("i", "<Del>", "<C-o>x", { desc = "Forward delete (simulate 'x')" })

-- Line Swapping keymaps
-- Normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

vim.keymap.set("i", "<A-j>", "<C-o>:m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<C-o>:m .-2<CR>==", { desc = "Move line up" })

-- Visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<A-l>", "w", { desc = "Move forward one word" })
vim.keymap.set("n", "<A-h>", "b", { desc = "Move backward one word" })


vim.keymap.set("i", "<A-l>", "<C-o>w", { desc = "Move word forward (insert)" })
vim.keymap.set("i", "<A-h>", "<C-o>b", { desc = "Move word back (insert)" })

vim.keymap.set("v", "<A-l>", "w", { desc = "Move forward one word" })
vim.keymap.set("v", "<A-h>", "b", { desc = "Move backward one word" })

vim.keymap.set("n", "<A-]>", "$", { desc = "Move to the end of the line" })
vim.keymap.set("n", "<A-[>", "^", { desc = "Move to the first non-whitespace char" })

vim.keymap.set("i", "<A-]>", "<C-o>$", { desc = "Move to the end of the line" })
vim.keymap.set("i", "<A-[>", "<C-o>^", { desc = "Move to the first non-whitespace char" })

vim.keymap.set("v", "<A-]>", "$", { desc = "Move to the end of the line" })
vim.keymap.set("v", "<A-[>", "^", { desc = "Move to the first non-whitespace char" })

-- Insert mode: Shift+Tab -> de-indent and stay in insert
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "De-indent line (insert mode)" })

-- Visual mode: Shift+Tab -> decrease indent for selection
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "De-indent selection (visual mode)" })

