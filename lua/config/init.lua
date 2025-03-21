local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.opt.termguicolors = true


require("lazy").setup({
  root = vim.fn.stdpath("data") .. "/lazy",
  spec = { {
    import = "plugins"
  } },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  defaults = {
    lazy = false,
    -- Don't automatically install new plugin versions
    version = nil
  },
  install = {
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "catppuccin", "default" }
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    -- don't notify about new updates
    notify = false,
    frequency = 86400
  },
  change_detection = {
    enabled = true,
    notify = false
  },
  performance = {
    cache = {
      enabled = true
    }
  },
  state = vim.fn.stdpath("state") .. "/lazy/state.json"
})

local modules = { "config.autocmds", "config.options", "config.keymaps" }

for _, mod in ipairs(modules) do
  pcall(require, mod)
end
