local Util = require('lazy.core.util')

local M = {}

M.autoformat = true

function M.toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    M.autoformat = true
  else
    M.autoformat = not M.autoformat
  end
  if M.autoformat then
    Util.info('Enabled format on save', { title = 'Format' })
  else
    Util.warn('Disabled format on save', { title = 'Format' })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function(event)
      if not M.autoformat then
        -- exit early if autoformat is not enabled
        return
      end
      local extra_lang_args = {
        javasciprt = { lsp_format = 'fallback', name = 'eslint' },
        javascriptreact = { lsp_format = 'fallback', name = 'eslint' },
        typescript = { lsp_format = 'fallback', name = 'eslint' },
        typescriptreact = { lsp_format = 'fallback', name = 'eslint' },
      }
      local extra_args = extra_lang_args[vim.bo[event.buf].filetype] or {}

      require('conform').format(vim.tbl_deep_extend('force', { bufnr = event.buf }, extra_args))
    end,
  })
end

return M
