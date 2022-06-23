-- NERDTree key binds
vim.api.nvim_set_keymap("", "<leader>o", ":NERDTree<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<leader>q", ":NERDTreeClose<CR><LF>", {noremap = true})

-- Buffer navigation
vim.api.nvim_set_keymap("", "<C-p>", ":bprevious<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<C-n>", ":bnext<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<C-d>", ":bdelete<CR><LF>", {noremap = true})
