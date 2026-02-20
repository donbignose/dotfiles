return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local set = vim.keymap.set

        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev hunk" })

        -- <leader>g group
        map("n", "<leader>gn", gs.next_hunk, { desc = "Next hunk" })
        map("n", "<leader>gp", gs.prev_hunk, { desc = "Prev hunk" })
        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
        map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>gb", gs.blame_line, { desc = "Blame line" })
        map("n", "<leader>gq", function()
          gs.setqflist("all")
        end, { desc = "Hunks → quickfix" })
      end,
    },
  },
}
