return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {"<leader>e", ":NvimTreeToggle<CR>", desc = "Open filetree"}
  },
  config = function()
		require("nvim-tree").setup({
      git = {
        ignore = false,
      },
      filters = {
        custom = {
          ".mypy_cache",
          ".vscode",
          ".venv",
          "uv.lock",
          ".pytest_cache",
          ".DS_Store",
          ".git",
          "__pycache__"
        },
      },
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
	})
  end
}

