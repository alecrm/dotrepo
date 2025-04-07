return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- shows file buffers as tabs
        numbers = "none",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_close_icon = false,
        show_buffer_close_icons = true,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
      },
    })

    -- Keymaps (normal mode)
    local map = vim.keymap.set
    map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
    map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
    map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
    map("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { desc = "Pick to close" })
    map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close current buffer" })
    map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
    map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", { desc = "Close right" })
    map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", { desc = "Close left" })
    map("n", "<leader>bm", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
    map("n", "<leader>bh", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
  end,
}
