return {{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup()

    -- Only add mappings when entering a normal (file) buffer
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function(args)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
        if buftype == "" then
          -- Define buffer-local Harpoon mappings
          vim.keymap.set("n", "<leader>e", function() harpoon:list():add() end,
            { desc = "Harpoon add", buffer = args.buf })
          vim.keymap.set("n", "<leader>o", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Harpoon menu", buffer = args.buf })
          vim.keymap.set("n", "<C-n>", function() harpoon:list():prev() end,
            { desc = "Harpoon prev", buffer = args.buf })
          vim.keymap.set("n", "<C-m>", function() harpoon:list():next() end,
            { desc = "Harpoon next", buffer = args.buf })
        end
      end
    })
  end
}}

