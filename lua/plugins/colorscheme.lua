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
      transparent_background = true,
      integrations = {
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          float = {
            border = "rounded",
            highlight = "NormalFloat",
          }
        }
      },
      highlight_overrides = {
        all = function(colors)
          return {
            NormalFloat = { bg = colors.base }, -- Change to another color if needed
            FloatBorder = { fg = colors.mauve, bg = colors.base },
          }
        end
      }
    }
  },
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
    "sainnhe/everforest",
    name = "everforest",
    lazy = true,
  },
  {
    -- Github - Github"s Neovim themes
    "projekt0n/github-nvim-theme",
    lazy = true
  }
}
