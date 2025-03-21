local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = "1000"
    })
  end
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "",
  command = ":%s/\\s\\+$//e"
})

autocmd("BufWritePre", {
  callback = function()
    local filetype = vim.bo.filetype

    -- Skip formatting for java files
    if filetype == "java" then
      return
    end

    vim.lsp.buf.format({
      filter = function()
        return true
      end,
      async = false,
    })
  end,
})

autocmd("Filetype", {
  pattern = { "xml", "html", "xhtml", "css", "scss", "yaml", "lua" },
  command = "setlocal shiftwidth=2 tabstop=2"
})

autocmd("Filetype", {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end
})

autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Check if the current buffer contains carriage return characters
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local contains_cr = false
    for _, line in ipairs(lines) do
      if line:find("\r") then
        contains_cr = true
        break
      end
    end

    -- If carriage return characters are found, remove them
    if contains_cr then
      vim.cmd("%s/\r//g")
    end
  end,
})
