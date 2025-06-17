local M = {}

local methods = vim.lsp.protocol.Methods

local function on_attach(client, bufnr)
  local function map(lhs, rhs, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
  end
  map('<leader>lh', vim.lsp.buf.hover)
  map('<leader>la', vim.lsp.buf.code_action)
  map('<leader>ln', vim.lsp.buf.rename)
  map('<leader>ls', vim.diagnostic.open_float)

  map('<C-h>', vim.lsp.buf.signature_help, 'i')

  -- NOTE: Folding is enabled for ruby_lsp to trigger an event required for indexing,
  -- even though folding itself is not used by me.
  if client:supports_method(methods.textDocument_foldingRange) and client.name == 'ruby_lsp' then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
end

function M.setup()
  local register_capability = vim.lsp.handlers[methods.client_registerCapability]
  vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end

    on_attach(client, vim.api.nvim_get_current_buf())

    return register_capability(err, res, ctx)
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('pb-lsp-attach', { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      on_attach(client, args.buf)
    end,
  })
end

return M
