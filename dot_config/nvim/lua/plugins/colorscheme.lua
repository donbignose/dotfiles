return {
  {
    "sainnhe/everforest",
    name = "everforest",
    priority = 1000,
    lazy = false,
    config = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme("everforest")
    end,
  },
}
