local M = {}

M.client_formatting_overrides = {
  eslint = function(client) client.server_capabilities.documentFormattingProvider = true end,
  tsserver = function(client) client.server_capabilities.documentFormattingProvider = false end,
}

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING') > 0
  local format_exclusions = { 'sumneko_lua', 'solargraph', 'dockerls', 'tsserver' }

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      if have_nls then return client.name == 'null-ls' end
      return not vim.tbl_contains(format_exclusions, client.name)
    end,
  })
end

function M.on_attach(client, buffer)
  if M.client_formatting_overrides[client.name] then
    M.client_formatting_overrides[client.name](client)
  end

  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. buffer, {}),
      buffer = buffer,
      callback = function() M.format() end,
    })
  end
end

return M
