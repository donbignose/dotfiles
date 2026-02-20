return {
  {
    "jedrzejboczar/possession.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "PossessionSave", "PossessionLoad", "PossessionDelete", "PossessionList" },
    keys = {
      { "<leader>ql", "<cmd>PossessionList<CR>", desc = "List sessions" },
      { "<leader>qn", "<cmd>PossessionSave<CR>", desc = "New/save session" },
      { "<leader>qd", "<cmd>PossessionDelete<CR>", desc = "Delete session" },
    },
    opts = {
      session_dir = vim.fn.expand("~/.local/share/nvim/sessions"),
      silent = false,
      load_silent = true,
      autosave = {
        current = false,
        on_load = false,
        on_quit = false,
      },
    },
  },
}
