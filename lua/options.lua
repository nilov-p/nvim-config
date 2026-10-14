vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.autoindent = true 
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "0"
vim.opt.showmatch = true
vim.opt.laststatus = 2

vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.splitbelow = true
vim.opt.splitright = true

local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.opt.shortmess:append("c")
vim.opt.isfname:append("@-@")
vim.opt.guicursor = ""
vim.opt.selection = "inclusive"
