return {
  {
    "tanvirtin/monokai.nvim",
    priority = 1000, -- load it early
    config = function()
      vim.cmd("colorscheme monokai")
    end
  }
}

