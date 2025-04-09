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
        day_filter = "pro",
        night_filter = "spectrum"
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
      }
    },
  },
}

