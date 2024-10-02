return {
  "m4xshen/hardtime.nvim",
  enable = false,
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    disabled_keys = {
      ["<Right>"] = { "n", "v" },
      ["<Left>"] = { "n", "v" },
    },
  },
}
