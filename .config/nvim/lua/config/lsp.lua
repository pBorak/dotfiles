local methods = vim.lsp.protocol.Methods
local icons = require('config.icons').diagnostics

local M = {}

local prefix = function(diagnostic)
  for d, icon in pairs(icons) do
    if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
  end
end

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = prefix,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.HINT] = icons.hint,
      [vim.diagnostic.severity.INFO] = icons.info,
    },
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    focusable = true,
    source = 'if_many',
    prefix = prefix,
  },
})

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

  if client:supports_method(methods.textDocument_foldingRange) then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
end

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

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    local server_configs = vim
      .iter(vim.api.nvim_get_runtime_file('lsp/*.lua', true))
      :map(function(file) return vim.fn.fnamemodify(file, ':t:r') end)
      :totable()
    vim.lsp.enable(server_configs)
  end,
})

return M
