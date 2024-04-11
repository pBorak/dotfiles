local M = {}

function M.setup()
  local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
  local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded', max_width = max_width, max_height = max_height }
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
    max_width = max_width,
    max_height = max_height,
  })
end

return M
