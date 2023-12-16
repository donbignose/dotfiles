return {
  "dzfrias/arena.nvim",
  event = "BufWinEnter",
  -- Calls `.setup()` automatically
  config = true,
  keys = { { "<leader>ba", "<cmd>ArenaToggle<cr>", desc = "Arena" } },
}
