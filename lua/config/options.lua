local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local s = vim.s
local indent = 2

opt.backspace = { "eol", "start", "indent" }
opt.clipboard = "unnamedplus"
vim.opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.syntax = "enable"

opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent
opt.shiftround = true -- use multiple of shiftwidth when indenting with "<" and ">"
vim.diagnostic.config({ float = { border = "rounded" } })

-- search
opt.hlsearch = true   -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true  -- smart case
opt.wildignore = opt.wildignore + { "*/node_modules/*", "*/.git/*", "*/vendor/*" }
opt.wildmenu = true   -- make tab completion for files/buffers act like bash

-- ui
opt.cursorline = true  -- highlight the current line
opt.laststatus = 2     -- only the last window will always have a status line
opt.lazyredraw = false -- don"t update the display while executing macros
opt.list = true
-- You can also add "space" or "eol", but I feel it"s quite annoying
opt.listchars = {
  tab = "┊ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "×"
}

-- Hide cmd line
opt.cmdheight = 0      -- more space in the neovim command line for displaying messages

opt.mouse = "a"        -- allow the mouse to be used in neovim
opt.number = true      -- set numbered lines
opt.scrolloff = 18     -- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 3  -- minimal number of screen columns to keep to the left and right (horizontal) of the cursor if wrap is `false`
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.splitbelow = true  -- open new split below
opt.splitright = true  -- open new split to the right
opt.wrap = false       -- display a long line

-- backups
opt.backup = false      -- create a backup file
opt.swapfile = false    -- creates a swapfile
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- autocomplete
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
opt.shortmess = opt.shortmess + {
  c = true
} -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"

-- By the way, -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline.
opt.showmode = true

-- perfomance
-- remember N lines in history
opt.history = 100    -- keep 100 lines of history
opt.redrawtime = 1500
opt.timeoutlen = 250 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 10
opt.updatetime = 100 -- signify default updatetime 4000ms is not good for async update

-- theme
opt.termguicolors = true -- enable 24-bit RGB colors

-- persistent undo
-- Don"t forget to create folder $HOME/.local/share/nvim/undo
local undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true -- enable persistent undo
opt.undodir = undodir
opt.undolevels = 1000
opt.undoreload = 10000

-- fold
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99 -- so folds are open by default
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Disable builtin plugins
local disabled_built_ins = { "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
  "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
  "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
  "synmenu", "optwin", "compiler", "bugreport", "ftplugin" }

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

cmd.colorscheme("catppuccin")
