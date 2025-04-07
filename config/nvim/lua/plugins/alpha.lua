return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- for icons
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
      "  ████╗  ██║██║   ██║██║████╗ ████║",
      "  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
      "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("p", "  Find Project", ":Telescope projects<CR>"),
      dashboard.button("s", "  Restore Session", ":lua require('persistence').load()<CR>"),
      dashboard.button("l", "  Last Session", ":lua require('persistence').load({ last = true })<CR>"),
      dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }

    -- Projects section
    local ok, project = pcall(require, "project_nvim.project")
    if ok and type(project.recent_projects) == "table" then
      local project_buttons = {}

      for i = 1, math.min(5, #project.recent_projects) do
        local path = project.recent_projects[i]
        local name = vim.fn.fnamemodify(path, ":t")
        table.insert(project_buttons, dashboard.button(
          tostring(i),
          "  " .. name,
          ":cd " .. path .. " | Alpha<CR>"
        ))
      end

      if #project_buttons > 0 then
        table.insert(dashboard.section.buttons.val, { type = "padding", val = 1 })
        table.insert(dashboard.section.buttons.val, dashboard.button("h", "📁 Recent Projects:", ""))
        vim.list_extend(dashboard.section.buttons.val, project_buttons)
      end
    end

    -- Footer
    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      return string.format("🚀 %d plugins loaded in %.2fms", stats.count, stats.startuptime)
    end

    -- Ensure everything is centered (vertically) based on screen height
    local function center_alpha()
      local height = vim.fn.winheight(0)
      local header_lines = #dashboard.section.header.val
      local button_lines = #dashboard.section.buttons.val
      local footer_lines = type(dashboard.section.footer.val) == "table" and #dashboard.section.footer.val or 1

      local total = header_lines + button_lines + footer_lines + 4
      local top_padding = math.max(0, math.floor((height - total) / 2) - 4)

      alpha.setup({
        layout = {
          { type = "padding", val = top_padding },
          dashboard.section.header,
          { type = "padding", val = 2 },
          dashboard.section.buttons,
          { type = "padding", val = 2 },
          dashboard.section.footer,
        },
        opts = {
          margin = 5,
          noautocmd = true,
        },
      })
    end

    -- Run it immediately
    center_alpha()

    -- Recenter when window resizes
    vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        -- Only recenter if Alpha is visible
        if vim.bo.filetype == "alpha" then
          center_alpha()
        end
      end,
    })
  end,
}
