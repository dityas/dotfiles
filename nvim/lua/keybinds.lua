-- NERDTree key binds
vim.api.nvim_set_keymap("", "<leader>o", ":NERDTree<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<leader>q", ":NERDTreeClose<CR><LF>", {noremap = true})

-- trigger coc
vim.api.nvim_set_keymap("", "<leader>n", "coc#refresh()", {noremap = true})
