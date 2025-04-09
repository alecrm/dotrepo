return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile", "VeryLazy" },
    opts = function()
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.SCOPE_ACTIVE, function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) < 2000
      end)

    local highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      }
      return {
        debounce = 200,
        indent = {
          char = "▏",
          tab_char = "▏",
          -- highlight = "IndentBlanklineChar",
          -- highlight = highlight,
        },
        scope = {
          injected_languages = true,
          highlight = highlight,
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

