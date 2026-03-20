return {
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    lazy = false,
    opts = {
      theme = "wave",
      transparent = false,
      integrations = {
        gitsigns = true,
        telescope = true,
        treesitter = true,
      },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}
