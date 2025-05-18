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
        if i + 1 <= #mods then
          handle_next(i + 1)
          vim.schedule(function() vim.cmd("startinsert") end)
        else
          handle_next(i + 1)
        end
        -- handle_next(i + 1)
        -- vim.schedule(function() vim.cmd("startinsert") end)
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
  desc   = "Safely return to dashboard",
  silent = true,
})
-- END OF CRAZY KEYMAP --


-- Other keymaps --
-- Rename symbol in scope
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Source current file
vim.keymap.set("n", "<leader>rr", "<cmd>luafile %<CR>", { desc = "Re-source current file" })

-- Restart LSP
vim.keymap.set("n", "<leader>rl", function()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Stop all clients for this buffer
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    client.config.cmd = nil  -- prevent auto-restart
    client.stop()
  end

  -- Delay the re-trigger just a bit
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath ~= "" then
    vim.schedule(function()
      vim.cmd("doautocmd BufReadPost " .. vim.fn.fnameescape(filepath))
    end)
  end
end, { desc = "Restart LSP for current buffer" })

-- Resize Windows
vim.keymap.set({ "n", "i", "v" }, "<C-Up>", ":resize -4<CR>")
vim.keymap.set({ "n", "i", "v" }, "<C-Down>", ":resize +4<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -4<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +4<CR>")


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
vim.keymap.set("n", "<A-J>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-K>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

vim.keymap.set("i", "<A-J>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-K>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

vim.keymap.set("v", "<A-J>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-K>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })


-- Moving characters in insert mode --
vim.keymap.set("i", "<A-j>", "<Esc>ja", { desc = "Move down one line" })
vim.keymap.set("i", "<A-k>", "<Esc>ka", { desc = "Move up one line" })
vim.keymap.set("i", "<A-h>", "<Esc>ha", { desc = "Move left one character" })
vim.keymap.set("i", "<A-l>", "<Esc>la", { desc = "Move right one character" })


-- Moving across a line --
-- Moving by a word
vim.keymap.set("n", "<A-L>", "w", { desc = "Move forward one word" })
vim.keymap.set("n", "<A-H>", "b", { desc = "Move backward one word" })

vim.keymap.set("i", "<A-L>", "<C-o>w", { desc = "Move forward one word" })
vim.keymap.set("i", "<A-H>", "<C-o>b", { desc = "Move backward one word" })

vim.keymap.set("v", "<A-L>", "w", { desc = "Move forward one word" })
vim.keymap.set("v", "<A-H>", "b", { desc = "Move backward one word" })

-- Moving to the beginning/end of a line
vim.keymap.set("n", "<A-]>", "$", { desc = "Move to the end of the line" })
vim.keymap.set("n", "<A-[>", "^", { desc = "Move to the first non-whitespace char" })

vim.keymap.set("i", "<A-]>", "<C-o>$", { desc = "Move to the end of the line" })
vim.keymap.set("i", "<A-[>", "<C-o>^", { desc = "Move to the first non-whitespace char" })

vim.keymap.set("v", "<A-]>", "$", { desc = "Move to the end of the line" })
vim.keymap.set("v", "<A-[>", "^", { desc = "Move to the first non-whitespace char" })


-- Clipboard shortcuts --
-- Easy copy to clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Copy to system clipboard' })

-- Replace current line with yanked lines
vim.keymap.set("n", "<leader>P", '"_ddP', { noremap = true, silent = true, desc = "Replace the current line with currently yanked lines" })


-- Duplicate line keymaps --
-- Helper Functions
------------------------------------------------------------------
-- Feed a raw key sequence (helper)
------------------------------------------------------------------
local function feed(keys)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    "n", false
  )
end

--------------------------------------------------------------
-- Duplicate current line, keep same column, return to Insert
-- dir =  1 → below   (yy p)
-- dir = -1 → above   (yy P)
--------------------------------------------------------------
local function duplicate_line(dir)
  local win        = vim.api.nvim_get_current_win()
  local row, col   = unpack(vim.api.nvim_win_get_cursor(win))
  local from_ins   = vim.fn.mode() == "i"

  if from_ins then vim.cmd("stopinsert") end   -- leave Insert, sync

  vim.cmd("normal! yy")
  vim.cmd("normal! " .. (dir == 1 and "p" or "P"))

  if dir == 1 then row = row + 1 end           -- adjust target row
  vim.api.nvim_win_set_cursor(win, { row, col })

  if from_ins then feed("a") end               -- pop back into Insert
end

------------------------------------------------------------------
-- Duplicate current Visual / Select block
-- dir =  1 → below   ("zp after end mark)
-- dir = -1 → above   ("zP before start mark)
------------------------------------------------------------------
local function duplicate_visual(dir)
  local vtype = vim.fn.visualmode()        -- 'v', 'V', or '\022' (<C-v>)

  feed('"zy')                              -- yank selection into reg z

  if dir == 1 then                         -- duplicate BELOW
    feed("`]")                             -- jump to end of selection
    feed('"zp')                            -- paste after it
  else                                     -- duplicate ABOVE
    feed("'[")                             -- jump to start of selection
    feed('"zP')                            -- paste before it
  end

  -- marks [ and ] now surround the *new* text
  if vtype == 'V' then                     -- line‑wise (V‑LINE)
    feed("`[V`]")
  elseif vtype == '\022' then              -- block‑wise (<C‑v>)
    feed("`[<C‑v>`]")
  else                                     -- character‑wise
    feed("`[v`]")
  end
end

------------------------------------------------------------------
-- Key‑maps (Visual + Select modes)
------------------------------------------------------------------
vim.keymap.set({ "n", "i" }, "<C-A-j>",  function() duplicate_line(1) end, { desc = "duplicate line below" })
vim.keymap.set({ "n", "i" }, "<C-A-k>", function() duplicate_line(-1) end, { desc = "duplicate line above" })

vim.keymap.set("v", "<C-A-j>",  function() duplicate_visual(1) end, { desc = "duplicate selection below" })
vim.keymap.set("v", "<C-A-k>", function() duplicate_visual(-1) end, { desc = "duplicate selection above" })
------------------------------------------------------------------
------------------------------------------------------------------
