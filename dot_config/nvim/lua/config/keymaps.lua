-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.keymap.set
set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true })
set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", { silent = true })
set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true })
set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true })
set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNavigateNext<CR>", { silent = true })
