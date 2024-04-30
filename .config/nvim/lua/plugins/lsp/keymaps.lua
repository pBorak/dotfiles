local M = {}

function M.on_attach(_, buffer)
  vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, { silent = true, buffer = buffer })
  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, { silent = true, buffer = buffer })
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, { silent = true, buffer = buffer })
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = buffer })
  vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { silent = true, buffer = buffer })
  vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, { silent = true, buffer = buffer })
  vim.keymap.set('n', '<leader>ls', vim.diagnostic.open_float, { silent = true, buffer = buffer })
end

return M
