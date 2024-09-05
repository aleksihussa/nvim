return {
  "nvim-java/nvim-java",
  config = function()
    --crete a keymap to go to definition
    --add keymap for this: require('java').test.view_last_report()
    vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>lua require('java').test.view_last_report()<CR>",
      { noremap = true, silent = true })


    require("java").setup({
      jdk = {
        auto_install = false
      },
      cmd = { "jdtls" }
    })
    local keymap_opts = { noremap = true, silent = true }
    require("lspconfig").jdtls.setup({
      on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
          { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, keymap_opts)
      end,
    })
  end,
}
