local pyright_clients = {}

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.py",
  callback = function(args)
    local bufnr = args.buf
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath == "" then return end

    local dirname = vim.fs.dirname(filepath)
    local root_files = { "pyproject.toml", "requirements.txt", ".git" }
    local root = vim.fs.find(root_files, { upward = true, path = dirname })[1]
    if not root then return end

    local root_dir = vim.fs.dirname(root)
    local venv_python = root_dir .. "/.venv/bin/python"
    local venv_path = root_dir .. "/.venv/bin/activate"
    local python_path = vim.fn.executable(venv_python) == 1 and venv_python or "python3"

    -- Save for Lualine
    vim.b[bufnr].venv_path = python_path

    local client_id = pyright_clients[root_dir]
    local client = client_id and vim.lsp.get_client_by_id(client_id)
    if client then
      vim.lsp.buf_attach_client(bufnr, client.id)
      return
    end

    vim.lsp.start({
      name = "pyright",
      cmd = { "pyright-langserver", "--stdio" },
      root_dir = root_dir,
      settings = {
        python = {
          pythonPath = python_path,
        },
      },
      on_attach = function(client, bnr)
        pyright_clients[root_dir] = client.id
        vim.b[bnr].venv_path = venv_path
      end,
    })
  end,
})

