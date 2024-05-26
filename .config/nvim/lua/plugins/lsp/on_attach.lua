local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('pb-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func) vim.keymap.set('n', keys, func, { buffer = event.buf }) end

      map('<leader>ld', vim.lsp.buf.definition)
      map('<leader>ld', vim.lsp.buf.definition)
      map('<leader>lr', vim.lsp.buf.references)
      map('<leader>lh', vim.lsp.buf.hover)
      map('<leader>la', vim.lsp.buf.code_action)
      map('<leader>ln', vim.lsp.buf.rename)
      map('<leader>ls', vim.diagnostic.open_float)
      vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = event.buf })

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup('pb-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('pb-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = 'pb-lsp-highlight', buffer = event2.buf })
          end,
        })
      end
    end,
  })
end

return M
