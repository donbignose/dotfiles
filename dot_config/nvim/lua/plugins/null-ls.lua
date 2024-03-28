return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  opts = function()
    local nls = require("null-ls")
    return {
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        nls.builtins.diagnostics.flake8.with({ extra_args = { "--extend-ignore=E203", "--max-line-length", "88" } }),
        nls.builtins.formatting.black,
        nls.builtins.formatting.autoflake,
      },
    }
  end,
}
