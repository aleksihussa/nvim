return {
  "nvim-java/nvim-java",
  config = function()
    require("java").setup({
      jdk = {
        auto_install = false
      },
      cmd = { "jdtls" }
    })
    require("lspconfig").jdtls.setup {
    }
  end,
}
