return {

 -- Mason core plugin
  {
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		event = "VeryLazy",
		cmd = { "Mason", "MasonInstall", "MasonUninstall" },
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗"
					}
				}
			})
		end,
	},

  -- Mason bridge to lspconfig
 {
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"folke/which-key.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()

			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
          "bashls",
				},
				automatic_installation = true,
			})

			local on_attach = function(_, bufnr)
				local wk = require("which-key")
				local opts = { buffer = bufnr, silent = true, noremap = true }

				wk.add({
					{ "gd",         vim.lsp.buf.definition,     desc = "Go to definition" },
					{ "gD",         vim.lsp.buf.declaration,    desc = "Go to declaration" },
					{ "gi",         vim.lsp.buf.implementation, desc = "Go to implementation" },
					{ "gf",         vim.lsp.buf.references,     desc = "Find references" },
					{ "K",          vim.lsp.buf.hover,          desc = "Hover docs" },
					{ "<leader>rn", vim.lsp.buf.rename,         desc = "Rename" },
					{ "<leader>ca", vim.lsp.buf.code_action,    desc = "Code Action" },
					{
						"<leader>fr",
						function() vim.lsp.buf.format({ async = true }) end,
						desc = "Format buffer",
					},
				}, {
					mode = "n",
					buffer = bufnr,
				})
			end

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						on_attach = on_attach,
					})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						on_attach = on_attach,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
        ["bashls"] = function()
          lspconfig.bashls.setup({
            on_attach = on_attach,
            filetypes = { "sh", "zsh" },
          })
        end,
			})
		end,
  },
}
