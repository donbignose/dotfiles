-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
local wk = require("which-key")

wk.register({
  v = {
    name = "venv",
  },
}, { prefix = "<leader>" })
