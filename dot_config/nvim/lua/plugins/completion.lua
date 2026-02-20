return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-e>"] = { "cancel" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },
      sources = {
        default = { "lsp", "path" },
        providers = {
          lsp = { name = "LSP", module = "blink.cmp.sources.lsp" },
          path = { name = "Path", module = "blink.cmp.sources.path" },
        },
      },
      completion = {
        ghost_text = { enabled = false },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      signature = { enabled = false },
    },
  },
}
