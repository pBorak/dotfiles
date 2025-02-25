local M = {}

local prefix = function(diagnostic)
  local icons = require('config.icons').diagnostics
  for d, icon in pairs(icons) do
    if diagnostic.severity == vim.diagnostic.severity[d:upper()] then return icon end
  end
end

function M.setup()
  local icons = require('config.icons').diagnostics

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
end

return M
