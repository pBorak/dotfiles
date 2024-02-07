local M = {}
local baseDefinitionHandler = vim.lsp.handlers['textDocument/definition']
local filter = require('util.init').filter

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

local function filter_react_dts(value)
  -- Depending on typescript version either uri or targetUri is returned
  if value.uri then
    return string.match(value.uri, '%.d.ts') == nil
  elseif value.targetUri then
    return string.match(value.targetUri, '%.d.ts') == nil
  end
end

function M.filter_definition_react_dtls_handler(err, result, method, ...)
  if vim.tbl_islist(result) and #result > 1 then
    local filtered_result = filter(result, filter_react_dts)
    return baseDefinitionHandler(err, filtered_result, method, ...)
  end

  baseDefinitionHandler(err, result, method, ...)
end

return M
