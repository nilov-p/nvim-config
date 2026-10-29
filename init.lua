vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("vim._core.ui2").enable({})
require('options')
require('keymaps')
require('autocmd')
require('usercmd')
require('pack')
require('lsp')
require('treesitter')
require('fterm')
require('notes')
