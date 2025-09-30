return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()

      local function get_venv_name()
        local full = vim.b.venv_path
        if not full then return nil end

        -- Step up from the binary to its containing folder
        -- e.g. from .../.venv/bin/python → ..../myproject
        local parent = vim.fn.fnamemodify(full, ":h:h:h")
        return vim.fn.fnamemodify(parent, ":t")
      end

      local function venv_status()
        if vim.bo.filetype ~= "python" then return "" end

        local name = get_venv_name()
        if name then
          return " " .. name
        end

        return ""
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics', },
          lualine_c = {'filename', },
          lualine_x = {'encoding', 'fileformat', 'filetype', venv_status },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            'filename',
            -- get_venv_path,
            'test'
          },
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end
  },

  -- UI components
  { "MunifTanjim/nui.nvim",        verison = false, branch = "main", lazy = true },

  { "nvim-tree/nvim-web-devicons", lazy = true, },

  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = false,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
    },
  },

  {
    "petertriho/nvim-scrollbar",
    -- event = { "BufReadPost", "BufNewFile" },
    lazy = true,
    opts = {
      set_highlights = false,
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
        "dashboard",
        "alpha",
        "lazy",
        "mason",
        "DressingInput",
        "",
      },
      handlers = {
        gitsigns = true,
      },
    },
  },

  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = true },
    },
    opts = {
      animation = { enable = true },
      autowidth = {
        enable = true,
        winwidth = 40,
      },
      ignore = {
        filetype = {
          "NvimTree",
          "neo-tree",
          "undotree",
          "gundo",
          "aerial",
        },
        buftype = {
          "nofile",
          "prompt",
          "help"
        },
      },
    },
    keys = { { "<leader>z", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" } },
    init = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 5
      vim.o.equalalways = false
    end,
  },
  
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    opts = function()
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.SCOPE_ACTIVE, function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) < 2000
      end)
      -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local scope_highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowOrange",
      }

      local indent_highlight = {
        "RainbowGreen",
        "RainbowCyan",
        "RainbowViolet",
      }

      
      return {
        debounce = 200,
        indent = {
          char = "▏",
          tab_char = "▏",
          -- highlight = "IndentBlanklineChar",
          highlight = indent_highlight,
        },
        scope = {
          injected_languages = true,
          highlight = scope_highlight,
          enabled = true,
          show_start = true,
          show_end = false,
          char = "▏",
          -- include = {
          --   node_type = { ["*"] = { "*" } },
          -- },
          -- exclude = {
          --   node_type = { ["*"] = { "source_file", "program" }, python = { "module" }, lua = { "chunk" } },
          -- },
        },
        exclude = {
          filetypes = {
            "help",
            "startify",
            "dashboard",
            "packer",
            "neogitstatus",
            "NvimTree",
            "Trouble",
            "alpha",
            "neo-tree",
          },
          buftypes = {
            "terminal",
            "nofile",
          },
        },
      }
    end,
    main = "ibl"
  },

  {
    "echasnovski/mini.hipatterns",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    desc = "Highlight colors in your code. Also includes Tailwind CSS support.",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          wip = { pattern = "%f[%w]()WIP()%f[%W]", group = "MiniHipatternsWip" },
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
        },
      }
    end,
  },
}

