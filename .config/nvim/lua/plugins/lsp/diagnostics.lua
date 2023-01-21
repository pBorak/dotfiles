local M = {}

function M.max_diagnostic(callback, namespace)
  return function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then max_severity_per_line[d.lnum] = d end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    callback(namespace, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

function M.setup()
  local icons = require('config.icons').diagnostics

  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      focusable = false,
      source = 'always',
      prefix = function(diag, i, _)
        local level = vim.diagnostic.severity[diag.severity]
        local prefix = string.format('%d. %s ', i, icons[level:lower()])
        return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
      end,
    },
  })

  local diagnostic_types = {
    { 'Hint', icon = icons.hint },
    { 'Error', icon = icons.error },
    { 'Warn', icon = icons.warn },
    { 'Info', icon = icons.info },
  }

  vim.fn.sign_define(vim.tbl_map(function(t)
    local hl = 'DiagnosticSign' .. t[1]
    return {
      name = hl,
      text = t.icon,
      texthl = hl,
      linehl = string.format('%sLine', hl),
    }
  end, diagnostic_types))

  local ns = vim.api.nvim_create_namespace('severe-diagnostics')
  local signs_handler = vim.diagnostic.handlers.signs
  vim.diagnostic.handlers.signs = {
    show = M.max_diagnostic(signs_handler.show, ns),
    hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
  }
end

return M
