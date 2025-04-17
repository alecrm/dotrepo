return {
	{
		"nvim-telescope/telescope.nvim",
		version = false, -- always use latest
		dependencies = {
			"nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
		},
		cmd = { "Telescope" },
		config = function()
			require("telescope").setup({
				defaults = {
          borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
          prompt_prefix = " ",
					file_ignore_patterns = {
  					"node_modules",
  					"%.git/",
  					"target/",
  					"dist/",
  					"build/",
  					"__pycache__/",
  					"squashfs%-root/",
  					"/%.?wine[^/]*/",
  					".steam/",
  					".jdks/",
  					".vscode/extensions/",
            ".mypy_cache",
            ".venv",
            ".DS_Store",
            ".pytest_cache",
            ".kube",
            ".sbt",
            ".nvm",
            ".bash_sessions",
            ".zsh_sessions",
            ".npm",
            ".local/share/nvim",
            "Library",
            ".docker",
            ".logmein"
  				},
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/*",
            "--glob=!node_modules/*",
            "--glob=!dist/*",
            "--glob=!build/*",
            "--glob=!__pycache__/*",
          }
        },
				pickers = {
					find_files = {
						find_command = {
							"fd", "--type", "f", "--strip-cwd-prefix",
							"--hidden",
							"--no-ignore",
							"--exclude", "node_modules",
							"--exclude", ".git",
							"--exclude", "target",
							"--exclude", "dist",
							"--exclude", "build",
							"--exclude", "__pycache__",
							"--exclude", "squashfs-root",
							"--exclude", "wine*",
							"--exclude", ".wine*",
							"--exclude", ".steam",
							"--exclude", ".jdks",
							"--exclude", ".vscode/extensions",
							"--exclude", "miniconda3",
							"--exclude", ".*-wine*",
              "--exclude", ".cache",
              "--exclude", ".m2",
              "--exclude", "snap",
              "--exclude", ".var",
						},
						hidden = true,
						no_ignore = true,
					},
				},
			})
		end,
  },
}
