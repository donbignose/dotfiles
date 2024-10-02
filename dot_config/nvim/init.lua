vim.g.python3_host_prog = "/Users/donbignose/.pyenv/versions/nvim/bin/python"
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("venv-selector").setup({
  -- poetry_path = "/home/donbignose/.cache/pypoetry/virtualenvs/",
  poetry_path = "/Users/donbignose/Library/Caches/pypoetry/virtualenvs",
})
