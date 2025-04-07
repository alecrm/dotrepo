
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "lua", "vim", "vimdoc", "markdown", "markdown_inline",
          "python", "javascript", "typescript", "html", "css", "json", "yaml"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      })
    end
  }
}

