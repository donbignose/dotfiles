return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable("make") == 1,
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "%.git/", "node_modules/" },
        },
        pickers = {
          find_files = {
            hidden = false,
            follow = false,
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- Camel/snake-case aware word motion
  {
    "chrisgrieser/nvim-spider",
    event = "BufReadPost",
    config = function()
      local spider = require("spider")
      local set = vim.keymap.set
      set({ "n", "o", "x" }, "w", function() spider.motion("w") end, { desc = "Spider w" })
      set({ "n", "o", "x" }, "e", function() spider.motion("e") end, { desc = "Spider e" })
      set({ "n", "o", "x" }, "b", function() spider.motion("b") end, { desc = "Spider b" })
    end,
  },
}
