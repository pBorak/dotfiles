local M = {}

function M.setup()
  local icons = require('config.icons').diagnostics

  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      spacing = 4,
      source = 'if_many',
      prefix = function(d)
        local level = vim.diagnostic.severity[d.severity]
        return string.format('%s %s', icons[level:lower()], d.message)
      end,
    },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      focusable = true,
      source = 'if_many',
      prefix = function(diag)
        local level = vim.diagnostic.severity[diag.severity]
        local prefix = string.format('%s ', icons[level:lower()])
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
end

return M
