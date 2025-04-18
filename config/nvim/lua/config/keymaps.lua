-- ABSOLUTELY INSANE KEYMAP TO HANDLE DASHBOARD
-- Try to find a Git root by looking for “.git” upward from a file’s dir
local function find_git_root(filepath)
  local dir = vim.fn.fnamemodify(filepath, ":p:h")
  local found = vim.fs.find(".git", { upward = true, path = dir })
  if found and #found > 0 then
    return vim.fn.fnamemodify(found[1], ":h")
  end
  return nil
end

vim.keymap.set("n", "<leader>q", function()
  local dash = require("snacks.dashboard")

  -- 1) collect all modified, “normal” buffers
  local mods = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buftype") == ""
       and vim.api.nvim_buf_get_option(buf, "modified")
    then
      mods[#mods + 1] = buf
    end
  end

  -- 2) recursive per‑buffer prompt
  local function handle_next(i)
    if i > #mods then
      -- done → wipe & reset to initial dashboard
      vim.cmd("bufdo! bwipeout!")
      vim.cmd("only")
      vim.cmd("enew")
      dash.open({ buf = vim.api.nvim_get_current_buf(), win = vim.api.nvim_get_current_win() })
      return
    end

    local buf      = mods[i]
    local fullpath = vim.api.nvim_buf_get_name(buf)
    local display

    if fullpath == "" then
      display = "[No Name]"
    else
      local root = find_git_root(fullpath)
      if root then
        local project = vim.fn.fnamemodify(root, ":t")
        local rel     = vim.fn.fnamemodify(fullpath, ":.")
        rel = rel:gsub("^%./", "")
        display = project .. "/" .. rel
      else
        display = fullpath
      end
    end

    -- use vanilla vim.ui.select()
    vim.ui.select(
      { "Save", "Skip", "Cancel" },
      { prompt = ("[%d/%d] Save buffer: %s?"):format(i, #mods, display) },
      function(choice)
        if not choice or choice == "Cancel" then
          return vim.notify("Aborted, buffers untouched", vim.log.levels.INFO)
        end
        if choice == "Save" then
          vim.api.nvim_buf_call(buf, function() vim.cmd("write") end)
        end
        handle_next(i + 1)
      end
    )
  end

  -- 3) entry point
  if #mods == 0 then
    -- no unsaved buffers → immediate wipe & dashboard
    vim.cmd("bufdo! bwipeout!")
    vim.cmd("only")
    vim.cmd("enew")
    dash.open({ buf = vim.api.nvim_get_current_buf(), win = vim.api.nvim_get_current_win() })
  else
    handle_next(1)
  end
end, {
  desc   = "Close everything & show initial Snacks dashboard (with per‑file save prompts)",
  silent = true,
})
-- END OF CRAZY KEYMAP --


-- Other keymaps --
-- Rename symbol in scope
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })


-- Add new line and move to it in normal mode
vim.keymap.set("n", "]<Space>", "o<Esc>", { silent=true, desc="Add new line below" })
vim.keymap.set("n", "[<Space>", "O<Esc>", { silent=true, desc="Add new line above" })


-- Indenting shortcuts --
-- Visual mode tab to indent, and stay in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "De-indent selection (visual mode)" })

-- De-indent the current line in insert mode
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "De-indent line (insert mode)" })


-- Delete key forward deletes
vim.keymap.set("i", "<C-d>", "<C-o>x", { desc = "Forward delete (simulate 'x')" })
vim.keymap.set("i", "<Del>", "<C-o>x", { desc = "Forward delete (simulate 'x')" })


-- Line Swapping keymaps --
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })


-- Moving across a line --
-- Moving by a word
vim.keymap.set("n", "<A-l>", "w", { desc = "Move forward one word" })
vim.keymap.set("n", "<A-h>", "b", { desc = "Move backward one word" })

vim.keymap.set("i", "<A-l>", "<C-o>w", { desc = "Move forward one word" })
vim.keymap.set("i", "<A-h>", "<C-o>b", { desc = "Move backward one word" })

vim.keymap.set("v", "<A-l>", "w", { desc = "Move forward one word" })
vim.keymap.set("v", "<A-h>", "b", { desc = "Move backward one word" })

-- Moving to the beginning/end of a line
vim.keymap.set("n", "<A-]>", "$", { desc = "Move to the end of the line" })
vim.keymap.set("n", "<A-[>", "^", { desc = "Move to the first non-whitespace char" })

vim.keymap.set("i", "<A-]>", "<C-o>$", { desc = "Move to the end of the line" })
vim.keymap.set("i", "<A-[>", "<C-o>^", { desc = "Move to the first non-whitespace char" })

vim.keymap.set("v", "<A-]>", "$", { desc = "Move to the end of the line" })
vim.keymap.set("v", "<A-[>", "^", { desc = "Move to the first non-whitespace char" })


-- Clipboard shortcuts --
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Copy to system clipboard' })

