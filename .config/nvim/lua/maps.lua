local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('i', 'jj', '<Esc>', opts)
keymap('n', '<C-J>', '<C-W><C-J>', opts)
keymap('n', '<C-K>', '<C-W><C-K>', opts)
keymap('n', '<C-L>', '<C-W><C-L>', opts)
keymap('n', '<C-H>', '<C-W><C-H>', opts)

--telescope
keymap('n', '<C-P>', [[<Cmd>lua require('telescope.builtin').find_files()<cr>]], opts)
keymap('n', '<C-F>', [[<Cmd>lua require('telescope.builtin').live_grep()<cr>]], opts)
keymap('n', '<C-B>', [[<Cmd>lua require('telescope.builtin').buffers()<cr>]], opts)

--nvim-tree
keymap("n", "<Leader>o", ":NvimTreeToggle<cr>", opts)
