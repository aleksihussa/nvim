return {
  -- Mason (package manager)
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall" },
    opts = {
      PATH = "prepend",
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = "󰚌",
        },
        keymaps = {
          toggle_server_expand = "<CR>",
          install_server = "i",
          update_server = "u",
          check_server_version = "c",
          update_all_servers = "U",
          check_outdated_servers = "C",
          uninstall_server = "X",
          cancel_installation = "<C-c>",
        },
      },
      max_concurrent_installers = 10,
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
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
        gopls = {},
        vimls = {},
        yamlls = {},
        eslint = {},
      },
    },
    config = function(_, opts)
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP floating window styling
      local max_width = math.floor(vim.o.columns * 0.3)
      vim.api.nvim_set_hl(0, "LspFloatBorder", { fg = "#89b4fa", bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#cdd6f4", bg = "#1e1e2e" })

      local border = {
        { "╭", "LspFloatBorder" },
        { "─", "LspFloatBorder" },
        { "╮", "LspFloatBorder" },
        { "│", "LspFloatBorder" },
        { "╯", "LspFloatBorder" },
        { "─", "LspFloatBorder" },
        { "╰", "LspFloatBorder" },
        { "│", "LspFloatBorder" },
      }

      local handlers_opts = {
        border = border,
        max_width = max_width,
        focusable = true,
        winhighlight = "Normal:NormalFloat,FloatBorder:LspFloatBorder",
      }

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        handlers_opts
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        handlers_opts
      )

      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end

        map("n", "K", vim.lsp.buf.hover)
        map("n", "<leader>a", vim.lsp.buf.code_action)
        map("n", "<leader>rr", vim.lsp.buf.references)
        map("n", "<leader>rn", vim.lsp.buf.rename)
        map("n", "gd", vim.lsp.buf.definition)
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = opts.servers or {}

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      require("mason-lspconfig").setup_handlers({
        function(server)
          require("lspconfig")[server].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server],
          })
        end,
      })
    end,
  },

  -- nvim-cmp Completion
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
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
      require("luasnip.loaders.from_vscode").lazy_load()

      return {
        completion = { completeopt = "menu,menuone,noinsert" },

        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:LspFloatBorder,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:LspFloatBorder",
          },
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
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
