-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("venv-selector").setup({
  poetry_path = "/home/donbignose/.cache/pypoetry/virtualenvs/",
})
