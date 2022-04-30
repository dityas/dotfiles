local set = vim.opt

-- Basic commands from .vim file

set.showmatch = true
set.compatible = false
set.ignorecase = true
set.hlsearch = true
set.incsearch = true
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftwidth = 4
set.autoindent = true
set.number = true
set.cc = "80"
set.cursorline = true
set.ttyfast = true
set.swapfile = false
set.background = "dark"
vim.cmd("syntax enable")

-- Plugins and all
local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.nvim")
-- Plug("dracula/vim")
Plug("savq/melange")
Plug("feline-nvim/feline.nvim")
Plug("scrooloose/nerdtree")
Plug("neoclide/coc.nvim", { branch = "release"})
vim.call("plug#end")

-- change colorscheme
set.termguicolors = true
vim.cmd("colorscheme melange")

