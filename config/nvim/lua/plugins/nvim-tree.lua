return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
		require("nvim-tree").setup({
      root_dirs            = { ".git", "package.json", "Makefile" },  -- define your project markers
      update_focused_file = {
        enable     = true,   -- keep the tree in sync with the buffer
        update_root = true,  -- if the buffer is outside the current root, jump the tree to its root dir
      },
      git = {
        ignore = false,
      },
      filters = {
        dotfiles = false,
        custom = {
          ".mypy_cache",
          ".vscode",
          ".venv",
          "uv.lock",
          ".pytest_cache",
          ".DS_Store",
          "^.git$",
          "__pycache__"
        },
      },
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    })
  end
}

