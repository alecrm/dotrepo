return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {"<leader>e", ":NvimTreeToggle<CR>", desc = "Open filetree"}
  },
  config = function()
		require("nvim-tree").setup({
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
	})
  end
}

