return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "NoiceMessage",
      callback = function(data)
        print("Noice message event:", vim.inspect(data))
      end,
    })

    local noice = require("noice")
    local notify = require("notify")

    noice.setup({
      notify = {
        enabled = true
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = true,
      },
    })

    vim.notify = noice.notify
  end,
}

