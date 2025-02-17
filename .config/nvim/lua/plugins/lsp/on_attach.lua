local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('pb-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func) vim.keymap.set('n', keys, func, { buffer = event.buf }) end

      map('<leader>ld', '<cmd>FzfLua lsp_definitions ignore_current_line=true<cr>')
      map('<leader>lr', '<cmd>FzfLua lsp_references ignore_current_line=true<cr>')
      map('<leader>lh', vim.lsp.buf.hover)
      map('<leader>la', vim.lsp.buf.code_action)
      map('<leader>ln', vim.lsp.buf.rename)
      map('<leader>ls', vim.diagnostic.open_float)
      vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = event.buf })
    end,
  })
end

return M
