local n = "n"

vim.keymap.set(n, "<leader>q", ":qa!<CR>", {})
vim.keymap.set(n, "<leader>s", ":w!<CR>", {})
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")


local builtin = require("telescope.builtin")
vim.keymap.set(n, "<leader>ff", builtin.find_files, {}) -- all files
vim.keymap.set(n, "<leader>fp", builtin.git_files, {})  -- git files
vim.keymap.set(n, "<leader>fg", builtin.live_grep, {})
vim.keymap.set(n, "<leader>fb", builtin.buffers, {})
vim.keymap.set(n, "<leader>fh", builtin.help_tags, {})
vim.keymap.set(n, "<leader>xx", function() require("trouble").toggle("diagnostics") end)
vim.keymap.set(n, "<leader>gg", ":LazyGit<CR>", {})
-- NvimTree
vim.keymap.set(n, "<leader>n", ":NvimTreeToggle<CR>", {})

-- Terminal
vim.wo.relativenumber = true
-- find and replace inside current file
vim.keymap.set(n, "<leader>fr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


vim.keymap.set(n, '<leader>dc', function() require('dap').continue() end)
vim.keymap.set(n, '<leader>dl', function() require('dap').run_last() end)
vim.keymap.set(n, '<leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set(n, '<leader>dq', function() require('dapui').close() end)
