return { {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  event = "InsertEnter",
  require("lazy").setup({
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  })

} }
