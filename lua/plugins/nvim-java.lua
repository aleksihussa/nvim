return {
  "nvim-java/nvim-java",
  config = function()

    require("java").setup({
      jdk = {
        auto_install = false
      },
			jdtls = {
				version = "1.46.1",
			},
      root_markers = {
        '.git',
      },
    })
    local keymap_opts = { noremap = true, silent = true }
    require("lspconfig").jdtls.setup({
      on_attach = function(_, bufnr)
    vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>lua require('java').test.view_last_report()<CR>",
      { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
          { noremap = true, silent = true })

        vim.api.nvim_set_keymap("n", "<A-f>", ":!mvn spotless:apply<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, keymap_opts)
      end,
    })
  end,
}
