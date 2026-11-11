-- NERDTree key binds
vim.api.nvim_set_keymap("", "<leader>o", ":NERDTree<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<leader>q", ":NERDTreeClose<CR><LF>", {noremap = true})

-- Buffer navigation
vim.api.nvim_set_keymap("", "<C-p>", ":bprevious<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<C-n>", ":bnext<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<C-d>", ":bdelete<CR><LF>", {noremap = true})
vim.api.nvim_set_keymap("", "<leader>cc", ":cclose<CR><LF>", {noremap = true})

-- Set the PDF viewer to Zathura
vim.g.vimtex_view_method = "zathura"

-- Ensure continuous compilation is enabled via latexmk
vim.g.vimtex_compiler_method = "latexmk"

-- Disable continuous compilation (compile on demand only)
vim.g.vimtex_compiler_latexmk = {
    continuous = 0
}
