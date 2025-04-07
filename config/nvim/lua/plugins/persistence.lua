return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    options = { "buffers", "curdir", "tabpages", "winsize" },
  },
  keys = {
    { "<leader>ps", function() require("persistence").load() end, desc = "Restore last session" },
    { "<leader>pl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>pd", function() require("persistence").stop() end, desc = "Don't save session" },
  },
}

