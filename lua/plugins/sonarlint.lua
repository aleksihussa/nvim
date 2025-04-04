return { {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-java/nvim-java" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("sonarlint").setup({
      server = {
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server/extension/analyzers/sonarjava.jar",
        },
      },
      filetypes = { "java" },
      settings = {
        sonarlint = {
          rules = {
            ["java:*"] = { level = "on" }, -- Enable all
          }
        }
      },
      autostart = true,
    })
  end
} }
