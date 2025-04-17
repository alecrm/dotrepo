return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    keys = { { "<leader>C", "<cmd>MonokaiProSelect<cr>", desc = "Select Monokai pro filter" } },
    opts = {
      transparent_background = false,
      devicons = true,
      filter = "pro",
      day_night = {
        enable = true,
        day_filter = "octagon",
        night_filter = "ristretto"
      },
      inc_search = "background",
      background_clear = {
        "nvim-tree",
        "bufferline",
        "telescope",
        "toggleterm"
      },
      plugins = {
        bufferline = {
          underline_selected = true,
          underline_visible = false,
          underline_fill = true,
          bold = false,
        },
        indent_blankline = {
          context_highlight = "pro",
          context_start_underline = true,
        }
      },
      override = function(c)
        local hp = require("monokai-pro.color_helper")
        local common_fg = hp.lighten(c.sideBar.foreground, 30)
        return {
          SnacksPicker = { bg = c.editor.background, fg = common_fg },
          SnacksPickerBorder = { bg = c.editor.background, fg = c.tab.unfocusedActiveBorder },
          SnacksPickerTree = { fg = c.editorLineNumber.foreground },
          NonText = { fg = c.base.dimmed3 },
        }
      end,
    },
  },
}

