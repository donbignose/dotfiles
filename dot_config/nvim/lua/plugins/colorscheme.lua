return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      transparent_background = false,
      integrations = {
        gitsigns = true,
        telescope = true,
        treesitter = true,
        lsp_trouble = false,
        mini = false,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
