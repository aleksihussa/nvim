return {
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    opts = {
      style = "night",
      transparent_background = true

    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true }
  },
  lazy = true,
  {

    -- Rose-pine - Soho vibes for Neovim
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      dark_variant = "main"
    },
    lazy = true
  },
  {
    -- Github - Github"s Neovim themes
    "projekt0n/github-nvim-theme",
    lazy = true
  }
}
