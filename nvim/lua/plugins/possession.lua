return {
  "gennaro-tedesco/nvim-possession",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  config = true,
  init = function()
    local possession = require("nvim-possession")
    vim.keymap.set("n", "<leader>ql", function()
      possession.list()
    end, { desc = "List session" })
    vim.keymap.set("n", "<leader>qn", function()
      possession.new()
    end, { desc = "Create session" })
    vim.keymap.set("n", "<leader>qu", function()
      possession.update()
    end, { desc = "Update session" })
    vim.keymap.set("n", "<leader>qd", function()
      possession.delete()
    end, { desc = "Delete current session" })
  end,
}
