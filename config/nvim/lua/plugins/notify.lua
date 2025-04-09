return {
  "rcarriga/nvim-notify",
  lazy = true,
  config = function()
    require("notify").setup({
      stages = "fade_in_slide_out",
      timeout = 5000,
      background_colour = "#000000",
      top_down = true,
      render = "default",
      fps = 60,
      minimum_width = 50,
      max_width = 80,
      max_height = 10,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })
    vim.notify = require("notify") -- replace default vim.notify
  end,
}

