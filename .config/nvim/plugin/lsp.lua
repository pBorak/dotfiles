local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local api = vim.api
local icons = gh.style.icons.lsp

--------------------------------------------------------------------------------
---- Commands
--------------------------------------------------------------------------------
local command = gh.command

-- A helper function to auto-update the quickfix list when new diagnostics come
-- in and close it once everything is resolved. This functionality only runs whilst
-- the list is open.
local function make_diagnostic_qf_updater()
  local cmd_id = nil
  return function()
    local buf = api.nvim_get_current_buf()
    if not api.nvim_buf_is_valid(buf) and api.nvim_buf_is_loaded(buf) then return end
    pcall(vim.diagnostic.setqflist, { open = false })
    gh.toggle_list('quickfix')
    if not gh.is_vim_list_open() and cmd_id then
      api.nvim_del_autocmd(cmd_id)
      cmd_id = nil
    end
    if cmd_id then return end
    cmd_id = api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        if gh.is_vim_list_open() then
          pcall(vim.diagnostic.setqflist, { open = false })
          if #fn.getqflist() == 0 then gh.toggle_list('quickfix') end
        end
      end,
    })
  end
end

command('LspDiagnostics', make_diagnostic_qf_updater())
gh.nnoremap('<leader>ll', '<Cmd>LspDiagnostics<CR>')
--------------------------------------------------------------------------------
---- Signs
--------------------------------------------------------------------------------
local diagnostic_types = {
  { 'Hint', icon = icons.hint },
  { 'Error', icon = icons.error },
  { 'Warn', icon = icons.warn },
  { 'Info', icon = icons.info },
}

fn.sign_define(vim.tbl_map(function(t)
  local hl = 'DiagnosticSign' .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    linehl = fmt('%sLine', hl),
  }
end, diagnostic_types))

--------------------------------------------------------------------------------
---- Handler overrides
--------------------------------------------------------------------------------

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- @see `:help vim.diagnostic`

local ns = api.nvim_create_namespace('severe-diagnostics')

local function max_diagnostic(callback)
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
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
}

local virt_text_handler = vim.diagnostic.handlers.virtual_text
vim.diagnostic.handlers.virtual_text = {
  show = max_diagnostic(virt_text_handler.show),
  hide = function(_, bufnr) virt_text_handler.hide(ns, bufnr) end,
}

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
  },
})

local max_width = math.max(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.max(math.floor(vim.o.lines * 0.3), 30)

-- NOTE: the hover handler returns the bufnr,winnr so can be used for mappings
lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded', max_width = max_width, max_height = max_height }
)

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
  border = 'rounded',
  max_width = max_width,
  max_height = max_height,
})

lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function() return lvl == 'ERROR' or lvl == 'WARN' end,
  })
end
