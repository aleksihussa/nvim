return { {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon.setup()
    vim.keymap.set("n", "<leader>e", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>o", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    vim.keymap.set("n", "<C-n>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<C-m>", function() harpoon:list():next() end)
  end
} }
