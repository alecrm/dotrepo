-- Swap Enter and 'o' keybindings in snacks explorer with window selection support
local M = {}

-- Create window picker similar to nvim-tree
local function pick_window()
  -- Store current windows
  local current_win = vim.api.nvim_get_current_win()
  local windows = {}
  local win_map = {}

  -- Skip floating and special windows, only include real code editor windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" and vim.fn.win_gettype(win) == "" then
      -- Check if this is a normal editing buffer
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

      -- Only include normal editing buffers, exclude special ones
      if buftype == "" and
         filetype ~= "NvimTree" and
         filetype ~= "explorer" and
         filetype ~= "Trouble" and
         filetype ~= "qf" and
         filetype ~= "help" and
         filetype ~= "snacks-explorer" and
         filetype ~= "aerial" and
         filetype ~= "notify" and
         win ~= current_win then
        table.insert(windows, win)
      end
    end
  end

  -- If no other windows or only one window, return it
  if #windows == 0 then
    return nil
  elseif #windows == 1 then
    return windows[1]
  end

  -- Letters for selection (use simple letters that are easy to recognize)
  local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  -- Create floating windows with labels for each target window
  local label_wins = {}
  local win_labels = {}


  for i, win in ipairs(windows) do
    local letter = letters:sub(i, i)
    win_map[letter] = win

    -- Get window dimensions and position
    local win_width = vim.api.nvim_win_get_width(win)
    local win_height = vim.api.nvim_win_get_height(win)

    -- Create a buffer for the label bar
    local buf = vim.api.nvim_create_buf(false, true)

    -- Create centered content for the bar
    local content = string.rep(" ", math.floor((win_width - 3) / 2)) ..
                    "[" .. letter .. "]" ..
                    string.rep(" ", math.floor((win_width - 3) / 2))

    -- Ensure the content fills the width of the window
    if #content < win_width then
      content = content .. string.rep(" ", win_width - #content)
    elseif #content > win_width then
      content = content:sub(1, win_width)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {content})

    -- Position the floating window at the bottom of the target window, full width
    local win_config = {
      relative = "win",
      win = win,
      width = win_width,
      height = 1,
      row = win_height - 1,
      col = 0,
      style = "minimal",
      focusable = false,
      zindex = 100,
    }

    local label_win = vim.api.nvim_open_win(buf, false, win_config)

    -- Define the PickerBlue highlight group for the window picker
    -- Create it every time to ensure it's available and with the correct colors
    vim.api.nvim_set_hl(0, "PickerBlue", {
      fg = "#ffffff", -- White text
      bg = "#4682b4", -- Light steel blue background
      bold = true     -- Bold text
    })

    -- Apply the highlighting to the window
    vim.api.nvim_win_set_option(label_win, "winhighlight", "Normal:PickerBlue")

    -- Store info for cleanup
    table.insert(label_wins, label_win)
    win_labels[letter] = {win = win, buffer = vim.api.nvim_win_get_buf(win)}
  end

  -- Create a clear message at the command line
  vim.api.nvim_command("redraw")  -- Force redraw to show the labels
  vim.api.nvim_echo({{"\nSelect window [" .. letters:sub(1, #windows) .. "]: ", "Question"}}, false, {})

  -- Get the pressed key
  local ok, pressed = pcall(function()
    return string.char(vim.fn.getchar()):upper()
  end)

  -- Clean up all the floating label windows
  for _, label_win in ipairs(label_wins) do
    if vim.api.nvim_win_is_valid(label_win) then
      local buf = vim.api.nvim_win_get_buf(label_win)
      vim.api.nvim_win_close(label_win, true)
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, {force = true})
      end
    end
  end

  -- Clear the prompt
  vim.api.nvim_echo({{"", ""}}, false, {})
  vim.api.nvim_command("redraw")  -- Force redraw to clear the visual noise

  -- Return the selected window
  if ok and win_map[pressed] then
    return win_map[pressed]
  end

  return nil
end

function M.setup()
  -- Run after snacks is loaded
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Make sure the Snacks plugin is available
      if not package.loaded["snacks"] then
        return
      end

      -- Access the needed modules
      local Snacks = require("snacks")
      local picker = require("snacks.picker")

      -- Define a custom "confirm" action that opens files externally
      picker.actions.external_open = function(p, item, _)
        if item then
          local _, err = vim.ui.open(item.file)
          if err then
            Snacks.notify.error("Failed to open `" .. item.file .. "`:\n- " .. err)
          end
        end
      end

      -- Define a custom action for the 'o' key that will open files in neovim with window selection
      -- and stay in the target window
      picker.actions.neovim_open = function(p, item, action)
        if not item then
          return
        elseif p.input.filter.meta.searching then
          require("snacks.explorer.actions").update(p, { target = item.file })
        elseif item.dir then
          require("snacks.explorer.tree"):toggle(item.file)
          require("snacks.explorer.actions").update(p, { refresh = true })
        else
          -- Make sure we have a valid file path
          local filepath = item.file
          if not filepath or filepath == "" then
            Snacks.notify.error("No valid file path to open")
            return
          end

          -- Use protected call to ensure we can handle errors
          local open_in_window = function(win_id, path)
            local success = pcall(function()
              -- Switch to the window
              vim.api.nvim_set_current_win(win_id)

              -- Open the file
              vim.cmd("edit " .. vim.fn.fnameescape(path))

              -- Position cursor if item has position data
              if item.pos then
                pcall(vim.api.nvim_win_set_cursor, win_id, {item.pos[1], item.pos[2]})
              end
            end)
            return success
          end

          -- Save the current window and buffer for returning later
          local explorer_win = vim.api.nvim_get_current_win()
          local explorer_buf = vim.api.nvim_get_current_buf()

          -- Count only actual code editor windows (exclude special buffers)
          local usable_windows = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            -- Skip floating windows and non-normal windows
            if vim.api.nvim_win_get_config(win).relative == "" and vim.fn.win_gettype(win) == "" then
              -- Skip explorer and special buffers
              local buf = vim.api.nvim_win_get_buf(win)
              local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
              local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

              -- Only include normal editing buffers
              if buftype == "" and
                 filetype ~= "NvimTree" and
                 filetype ~= "explorer" and
                 filetype ~= "Trouble" and
                 filetype ~= "qf" and
                 filetype ~= "help" and
                 filetype ~= "snacks-explorer" and
                 filetype ~= "aerial" and
                 filetype ~= "notify" and
                 win ~= explorer_win then
                table.insert(usable_windows, win)
              end
            end
          end

          -- If there's only the explorer window, open in a split
          if #usable_windows == 0 then
            -- Create a vertical split and keep focus on it
            vim.cmd("vsplit " .. vim.fn.fnameescape(filepath))

            -- Keep focus on the new window
            return
          end

          -- If there are multiple windows, use window picker
          if #usable_windows > 1 then
            local target_win = pick_window()

            -- If window selection successful, open file there
            if target_win and vim.api.nvim_win_is_valid(target_win) then
              -- Try to open in the selected window and keep focus there
              local success = open_in_window(target_win, filepath)

              -- Keep focus on the target window (don't return to explorer)

              if success then
                return
              end
              -- If we're here, something went wrong - fall through to the fallback
            end

            -- Window selection failed or error opening file - use the first usable window
            Snacks.notify.warn("Window selection failed, using fallback window")
          end

          -- There's only one non-explorer window or we're using fallback - use the first available window
          local target = usable_windows[1]
          if target and vim.api.nvim_win_is_valid(target) then
            -- Try to open in the target window and keep focus there
            open_in_window(target, filepath)

            -- Keep focus on the target window (don't return to explorer)
          else
            -- Last resort fallback - split from current window and keep focus on the new split
            vim.cmd("vsplit " .. vim.fn.fnameescape(filepath))
            -- No need to return to explorer - keep focus on the new window
          end
        end
      end

      -- Define a duplicate action for Shift+O that will open files but keep focus on explorer
      picker.actions.neovim_open_keep_focus = function(p, item, action)
        if not item then
          return
        elseif p.input.filter.meta.searching then
          require("snacks.explorer.actions").update(p, { target = item.file })
        elseif item.dir then
          require("snacks.explorer.tree"):toggle(item.file)
          require("snacks.explorer.actions").update(p, { refresh = true })
        else
          -- Save the current explorer window and buffer for returning later
          local explorer_win = vim.api.nvim_get_current_win()
          local explorer_buf = vim.api.nvim_get_current_buf()

          -- Make sure we have a valid file path
          local filepath = item.file
          if not filepath or filepath == "" then
            Snacks.notify.error("No valid file path to open")
            return
          end

          -- Use protected call to ensure we can handle errors
          local open_in_window = function(win_id, path)
            local success = pcall(function()
              -- Switch to the window
              vim.api.nvim_set_current_win(win_id)

              -- Open the file
              vim.cmd("edit " .. vim.fn.fnameescape(path))

              -- Position cursor if item has position data
              if item.pos then
                pcall(vim.api.nvim_win_set_cursor, win_id, {item.pos[1], item.pos[2]})
              end

              -- Return focus to explorer window
              vim.api.nvim_set_current_win(explorer_win)
            end)
            return success
          end

          -- Count only actual code editor windows (exclude special buffers)
          local usable_windows = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if win ~= explorer_win and vim.api.nvim_win_get_config(win).relative == "" and vim.fn.win_gettype(win) == "" then
              -- Skip explorer and special buffers
              local buf = vim.api.nvim_win_get_buf(win)
              local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
              local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

              -- Only include normal editing buffers
              if buftype == "" and
                 filetype ~= "NvimTree" and
                 filetype ~= "explorer" and
                 filetype ~= "Trouble" and
                 filetype ~= "qf" and
                 filetype ~= "help" and
                 filetype ~= "snacks-explorer" and
                 filetype ~= "aerial" and
                 filetype ~= "notify" and
                 win ~= explorer_win then
                table.insert(usable_windows, win)
              end
            end
          end

          -- If there's only the explorer window, open in a split
          if #usable_windows == 0 then
            -- Create a vertical split
            local curwin = vim.api.nvim_get_current_win()
            vim.cmd("vsplit " .. vim.fn.fnameescape(filepath))
            -- Return to explorer
            vim.api.nvim_set_current_win(curwin)
            return
          end

          -- If there are multiple windows, use window picker
          if #usable_windows > 1 then
            local target_win = pick_window()

            -- If window selection successful, open file there
            if target_win and vim.api.nvim_win_is_valid(target_win) then
              -- Try to open in the selected window and return focus
              local success = open_in_window(target_win, filepath)

              if success then
                return
              end
              -- If we're here, something went wrong - fall through to the fallback
            end

            -- Window selection failed or error opening file - use the first usable window
            Snacks.notify.warn("Window selection failed, using fallback window")
          end

          -- There's only one non-explorer window or we're using fallback - use the first available window
          local target = usable_windows[1]
          if target and vim.api.nvim_win_is_valid(target) then
            -- Try to open in the target window
            open_in_window(target, filepath)
          else
            -- Last resort fallback - split from current window
            local curwin = vim.api.nvim_get_current_win()
            vim.cmd("vsplit " .. vim.fn.fnameescape(filepath))
            -- Return to explorer
            vim.api.nvim_set_current_win(curwin)
          end
        end
      end

      -- Override the explorer keybindings
      if picker.sources and picker.sources.explorer and picker.sources.explorer.win and picker.sources.explorer.win.list then
        local keys = picker.sources.explorer.win.list.keys

        -- Swap the 'o' and Enter key behaviors and add Shift+O
        keys["o"] = "neovim_open" -- 'o' key will now open in neovim with window selection and stay in target
        keys["O"] = "neovim_open_keep_focus" -- Shift+O opens file but keeps focus in explorer
        keys["<CR>"] = "external_open" -- Enter key will now open externally
      end
    end,
  })
end

return M
