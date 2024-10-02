return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  enable = false,
  config = function()
    require("refactoring").setup()
  end,
  keys = {
    {
      mode = { "x" },
      "<leader>cRe",
      function()
        require("refactoring").refactor("Extract Function")
      end,
      desc = "Extract Function",
    },
    {
      mode = { "x" },
      "<leader>cRf",
      function()
        require("refactoring").refactor("Extract Function To File")
      end,
      desc = "Extract Function To File",
    },
    {
      mode = { "x" },
      "<leader>cRv",
      function()
        require("refactoring").refactor("Extract Variable")
      end,
      desc = "Extract Variable",
    },
    {
      mode = { "n" },
      "<leader>cRI",
      function()
        require("refactoring").refactor("Inline Function")
      end,
      desc = "Inline Function",
    },
    {
      mode = { "n", "x" },
      "<leader>cRi",
      function()
        require("refactoring").refactor("Inline Variable")
      end,
      desc = "Inline Variable",
    },
    {
      mode = { "n" },
      "<leader>cRb",
      function()
        require("refactoring").refactor("Extract Block")
      end,
      desc = "Extract Block",
    },
    {
      mode = { "n" },
      "<leader>cRbf",
      function()
        require("refactoring").refactor("Extract Block To File")
      end,
      desc = "Extract Block To File",
    },
  },
}
