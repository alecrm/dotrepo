return {
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        -- { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    opts = {
      attach_mode = "global",
      show_guides = true,
      layout = {
        max_width = 1000, -- cap width at 40 columns or 20% of screen
        min_width = 30,          -- never smaller than 20
        default_direction = "prefer_right",
        placement = "window",
        preserve_equality = false,
        resize_to_content = true,
        win_opts = {
          winfixwidth = true,
          number = false,
          relativenumber = false,
          signcolumn = "no",
          foldcolumn = "0",
          statuscolumn = "",
          numberwidth = 1,
        }
      },
    },
      init = function()
      local grp = vim.api.nvim_create_augroup("AerialEnforceGutters", { clear = true })

      -- Enforce slim/no gutters whenever the Aerial window appears or is re-entered
      vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
        group = grp,
        pattern = "aerial",
        callback = function(args)
          -- keep the Aerial pane from showing any extra columns
          vim.diagnostic.disable(args.buf)        -- avoid LSP signs flipping signcolumn
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.statuscolumn = ""
          vim.opt_local.numberwidth = 1
          vim.opt_local.winfixwidth = true
        end,
      })
    end,
    -- init = function()
    --   -- Keep the Aerial window slim: no gutters
    --   local grp = vim.api.nvim_create_augroup("AerialSlimGutters", { clear = true })
    --   vim.api.nvim_create_autocmd("FileType", {
    --     group = grp,
    --     pattern = "aerial",
    --     callback = function()
    --       vim.opt_local.number = false
    --       vim.opt_local.relativenumber = false
    --       vim.opt_local.signcolumn = "no"
    --       vim.opt_local.foldcolumn = "0"
    --       vim.opt_local.statuscolumn = ""
    --       vim.opt_local.numberwidth = 1
    --     end,
    --   })
    --
    --
    --  end,

    keys = {
      {
        "<leader>ao",
        function()
          local has_win = (vim.fn.exists(":WindowsDisableAutowidth") == 2)
          local focus = vim.api.nvim_get_current_win()

          local function find_aerial_win()
            for _, w in ipairs(vim.api.nvim_list_wins()) do
              local b = vim.api.nvim_win_get_buf(w)
              if vim.api.nvim_get_option_value("filetype", { buf = b }) == "aerial" then
                return w
              end
            end
          end

          local aw = find_aerial_win()
          if not aw then
            if has_win then pcall(vim.cmd, "WindowsDisableAutowidth") end
            vim.cmd("AerialOpen! left")             -- keeps focus in code window
            aw = find_aerial_win()
            if aw then
              -- lock a minimum so it won't get squeezed
              vim.api.nvim_win_call(aw, function()
                vim.opt_local.winfixwidth = true
                local minw = 28                      -- match your layout.min_width
                local w = vim.api.nvim_win_get_width(0)
                if w < minw then pcall(vim.api.nvim_win_set_width, 0, minw) end
              end)
            end
            -- restore focus and re-enable autowidth so the focused window grows to winwidth
            if vim.api.nvim_win_is_valid(focus) then vim.api.nvim_set_current_win(focus) end
            if has_win then pcall(vim.cmd, "WindowsEnableAutowidth") end
          else
            -- close Aerial; leave autowidth on
            vim.cmd("AerialClose")
          end
        end,
        desc = "Outline",
      },
        -- { "<leader>ao", "<cmd>AerialToggle! left<cr>", desc = "Outline" },
      { "{", "<cmd>AerialPrev<cr>" },
      { "}", "<cmd>AerialNext<cr>" },
    },
  },
}
