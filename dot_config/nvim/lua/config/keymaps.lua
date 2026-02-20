local set = vim.keymap.set

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keep cursor centered on J
set("n", "J", "mzJ`z")

-- Clear search highlight
set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Tmux navigation
set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true })
set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { silent = true })
set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true })
set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true })
set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNext<CR>", { silent = true })

-- Diagnostics navigation
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- <leader>f — find / navigation (telescope)
set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
set("n", "<leader>fd", function()
  require("telescope.builtin").find_files({ cwd = "~/.local/share/chezmoi" })
end, { desc = "Find in dotfiles" })

-- <leader>g — git / hunks / diff (gitsigns wired via on_attach)

-- <leader>x — diagnostics / quickfix
set("n", "<leader>xx", function()
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Workspace diagnostics → quickfix" })
set("n", "<leader>xd", function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Document diagnostics → loclist" })
set("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Open location list" })

-- <leader>t — terminal
set("n", "<leader>tt", "<cmd>terminal<CR>", { desc = "Open terminal" })

-- <leader>q — session (possession keymaps wired in session.lua)
