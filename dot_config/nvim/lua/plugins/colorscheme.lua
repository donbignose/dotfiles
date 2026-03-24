return {
  {
    "sainnhe/everforest",
    name = "everforest",
    priority = 1000,
    lazy = true,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
    end,
  },
  {
    "datsfilipe/vesper.nvim",
    name = "vesper",
    priority = 1000,
    lazy = true,
  },
  {
    "theme-loader",
    dir = vim.fn.stdpath("config") .. "/lua/plugins",
    priority = 999,
    lazy = false,
    config = function()
      local theme_file = vim.fn.stdpath("config") .. "/theme.txt"
      local f = io.open(theme_file, "r")
      local theme = f and f:read("*l") or "everforest"
      if f then f:close() end
      vim.cmd.colorscheme(theme)
    end,
  },
}
