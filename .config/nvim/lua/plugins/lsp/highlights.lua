local M = {}

function M.on_attach(client, buffer)
  if client.supports_method('textDocument/documentHighlight') then
    local group = vim.api.nvim_create_augroup('LspHiglight.' .. buffer, {})

    vim.api.nvim_create_autocmd('CursorHold', {
      group = group,
      buffer = buffer,
      callback = function() vim.lsp.buf.document_highlight() end,
    })

    vim.api.nvim_create_autocmd('CursorMoved', {
      group = group,
      buffer = buffer,
      callback = function() vim.lsp.buf.clear_references() end,
    })
  end
end

return M
