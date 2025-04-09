return {
  "Bekaboo/dropbar.nvim",
  event = "BufReadPost",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- optional: for icons
  },
  config = function()
    require("dropbar").setup()
  end,
}

