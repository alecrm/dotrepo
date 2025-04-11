return {
  "folke/drop.nvim",
  event = "VimEnter",
  -- lazy = true,
  config = function()
    require("config.drop").setup()
  end
}
