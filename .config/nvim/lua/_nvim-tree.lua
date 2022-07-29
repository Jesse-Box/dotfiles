local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

keymap("n", "<Leader>e", ":NvimTreeToggle<cr>", opts)

nvim_tree.setup()
