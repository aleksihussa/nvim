return {
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-jdtls",
    "williamboman/mason.nvim",
  },
  config = function()
    require("java").setup({
      jdk = {
        auto_install = false
      },
      jdtls = {
        enable = true,
        version = "1.46.1",
      },
      java_test = {
        enable = true,
        version = "0.43.1",
      },
      java_debug_adapter = {
        enable = true,
        version = "0.58.1",
      },
      root_markers = {
        ".git",
      },
    })

    -- Ugly bubblegum workaround but necessary since something is wrong currentyle in the nvim-java and how it combines nvim-jdtls with nvim-java-test internally
    local function get_java_bundles()
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"
      local glob = vim.fn.glob

      local test_jars = glob(mason_path .. "java-test/extension/server/*.jar", 1, 1)
      local debug_jars = glob(mason_path .. "java-debug-adapter/extension/server/*.jar", 1, 1)

      return vim.tbl_extend("force", debug_jars, test_jars)
    end

    local keymap_opts = { noremap = true, silent = true }

    require("lspconfig").jdtls.setup({
      settings = {
        ["java.settings.url"] ="file://" .. vim.fn.expand("~/.config/nvim/rule/java-settings.prefs")
      },
      on_attach = function(_, bufnr)
        vim.api.nvim_set_keymap("n", "<leader>tr", "<cmd>lua require('java').test.view_last_report()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
        vim.api.nvim_set_keymap("n", "<A-f>", ":!mvn spotless:apply<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, keymap_opts)
      end,
      init_options = {
        bundles = get_java_bundles()
      }
    })
  end,
}

