return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup({
      -- Detect root via these patterns
      detection_methods = { "lsp", "pattern" },
      patterns = {
        "pyproject.toml",
        "setup.cfg",
        ".git",
        "requirements.txt",
        "Makefile",
        "package.json",
      },
      silent_chdir = true,
      scope_chdir = 'tab',
    })

    -- Optional: Integrate with Telescope
    require("telescope").load_extension("projects")
  end,
}

