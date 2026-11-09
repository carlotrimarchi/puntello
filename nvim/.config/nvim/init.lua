vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.timeoutlen = 300

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>so", function() vim.cmd("source /Users/carlo/dev/puntello/nvim/.config/nvim/init.lua") end, {desc = "Reload init.lua"})

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true     -- persistent undo history across sessions
vim.opt.splitright = true   -- vertical splits open to the right
vim.opt.splitbelow = true   -- horizontal splits open below
vim.opt.updatetime = 250    -- delay before events like LSP diagnostics/CursorHold trigger (default 4000ms)

-- Spacing and indentation
-- Use tabs by default, with a visual size of 4 spaces. 
-- expandtab: use real tabs instead of spaces
-- shiftwidth: indentation width used by >>, <<, and auto-indent
-- tabstop: visual width of an existing tab character
-- (the 2 options have the same value so indent commands can always insert a tab, no mixed spacing)
local indent_width = 4
vim.opt.expandtab = false
vim.opt.shiftwidth = indent_width
vim.opt.tabstop = indent_width
vim.opt.smartindent = true

-- netrw
-- netrw options, in case oil.nvim is not installed or not working.
vim.g.netrw_banner = 0        -- hide the informational banner at the top
vim.g.netrw_liststyle = 3     -- tree view instead of a flat list
vim.g.netrw_browse_split = 4  -- open selected files in the previous window instead of a new one
vim.g.netrw_altv = 1          -- vertical splits open to the right
vim.g.netrw_winsize = 25      -- percentage of width netrw takes up when opened in a split
