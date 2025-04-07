return {
	"lewis6991/gitsigns.nvim",
	version = false,
	event = { "BufReadPre", "BufNewFile"},
	config = function()
		require("gitsigns").setup({
			signs = {
				add          = { text = "+" },
				change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      current_line_blame = true, -- shows git blame on the current line
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

				require("which-key").add({
					{ "<leader>h", buffer = bufnr, group = "GitSigns" }
				})


        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(gs.next_hunk)
          return "<Ignore>"
        end, "Next hunk")

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(gs.prev_hunk)
          return "<Ignore>"
        end, "Prev hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, "Stage hunk (visual)")
        map("v", "<leader>hr", function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, "Reset hunk (visual)")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line{full=true} end, "Blame line")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")
        map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted")
				map("n", "<leader>hq", function()
					vim.cmd("wincmd o")
					vim.cmd("diffoff!")
				end, "Exit diff view")
      end
		})
	end
}
