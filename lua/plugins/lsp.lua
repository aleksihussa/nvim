return {
  -- Mason (new repos)
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = { PATH = "prepend", max_concurrent_installers = 10 },
  },

  -- LSP core
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = {
      autoformat = false,
      servers = {
        jsonls = {},
        dockerls = {},
        bashls = {},
        vimls = {},
        yamlls = {},
        eslint = {},
        -- NOTE: no jdtls here
      },
    },
    config = function(_, opts)
      -- Rounded borders everywhere
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      })
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- Modern buffer-local maps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
          end
          map("n", "gd",         vim.lsp.buf.definition,  "Goto Definition")
          map("n", "K",          vim.lsp.buf.hover,       "Hover")
          map("n", "<leader>a",  vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>rr", vim.lsp.buf.references,  "References")
          map("n", "<leader>rn", vim.lsp.buf.rename,      "Rename")
        end,
      })

      -- Capabilities (nvim-cmp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- mason-lspconfig ensure + setup
      local servers = opts.servers or {}
      local mlsp = require("mason-lspconfig")
      mlsp.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
        -- 👇 prevent Mason from auto-enabling jdtls
        automatic_enable = {
          exclude = { "jdtls" },
        },
      })

      if mlsp.setup_handlers then
        mlsp.setup_handlers({
          function(server_name)
            -- 👇 extra guard in case automatic_enable is ignored by your version
            if server_name == "jdtls" then return end
            local server_opts = servers[server_name] or {}
            server_opts.capabilities =
              vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
            require("lspconfig")[server_name].setup(server_opts)
          end,
        })
      else
        -- Older versions: loop directly
        for name, server_opts in pairs(servers) do
          if name ~= "jdtls" then
            server_opts.capabilities =
              vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
            require("lspconfig")[name].setup(server_opts)
          end
        end
      end
    end,
  },

  -- nvim-cmp (Enter confirm, Tab / S-Tab navigate; rounded popups)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function()
      local cmp, luasnip = require("cmp"), require("luasnip")
      luasnip.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })
      require("luasnip.loaders.from_vscode").lazy_load()

      return {
        completion = { completeopt = "menu,menuone,noinsert" },
        window = {
          completion = { border = "rounded" },
          documentation = { border = "rounded" },
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = {
          ["<C-p>"]   = cmp.mapping.select_prev_item(),
          ["<C-n>"]   = cmp.mapping.select_next_item(),
          ["<C-d>"]   = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]   = cmp.mapping.scroll_docs(4),
          ["<C-Space>"]= cmp.mapping.complete(),
          ["<C-e>"]   = cmp.mapping.close(),
          ["<CR>"]    = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                local buf = vim.api.nvim_get_current_buf()
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                if byte_size > 1024 * 1024 then return {} end
                return { buf }
              end,
            },
          },
          { name = "nvim_lua" },
          { name = "path" },
        },
      }
    end,
  },
}

