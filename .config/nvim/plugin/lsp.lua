local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local api = vim.api
local icons = gh.style.icons.lsp

--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local get_augroup = function(bufnr)
  assert(bufnr, 'A bufnr is required to create an lsp augroup')
  return fmt('LspCommands_%d', bufnr)
end

local format_exclusions = { 'sumneko_lua', 'solargraph', 'dockerls' }

local function formatting_filter(client) return not vim.tbl_contains(format_exclusions, client.name) end

local function setup_autocommands(client, bufnr)
  local group = get_augroup(bufnr)
  -- Clear pre-existing buffer autocommands
  pcall(api.nvim_clear_autocmds, { group = group, buffer = bufnr })

  local cmds = {}

  if client and client.supports_method('textDocument/documentHighlight') then
    table.insert(cmds, {
      event = { 'CursorHold' },
      buffer = bufnr,
      desc = 'LSP: Document Highlight',
      command = function() vim.lsp.buf.document_highlight() end,
    })
    table.insert(cmds, {
      event = 'CursorMoved',
      desc = 'LSP: Document Highlight (Clear)',
      buffer = bufnr,
      command = function() vim.lsp.buf.clear_references() end,
    })
  end
  if client and client.server_capabilities.documentFormattingProvider then
    table.insert(cmds, {
      event = 'BufWritePre',
      buffer = bufnr,
      desc = 'Format the current buffer on save',
      command = function(args)
        vim.lsp.buf.format({
          bufnr = args.bufnr,
          filter = formatting_filter,
        })
      end,
    })
  end
  gh.augroup(group, cmds)
end
--------------------------------------------------------------------------------
---- Mappings
--------------------------------------------------------------------------------
---Setup mapping when an lsp attaches to a buffer
---@param _ table lsp client
local function setup_mappings(_)
  gh.nnoremap('<leader>ld', vim.lsp.buf.definition)
  gh.nnoremap('<leader>lr', vim.lsp.buf.references)
  gh.nnoremap('<leader>lh', vim.lsp.buf.hover)
  gh.inoremap('<C-h>', vim.lsp.buf.signature_help)
  gh.nnoremap('<leader>la', vim.lsp.buf.code_action)
  gh.nnoremap('<leader>ln', vim.lsp.buf.rename)
  gh.nnoremap('<leader>lf', vim.lsp.buf.format)

  gh.nnoremap('[d', function() vim.diagnostic.goto_prev() end)
  gh.nnoremap(']d', function() vim.diagnostic.goto_next() end)
end
-----------------------------------------------------------------------------//
-- Lsp setup/teardown
-----------------------------------------------------------------------------//
---Add buffer local mappings, autocommands, tagfunc etc for attaching servers
---@param client table lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  local active = vim.lsp.get_active_clients({ bufnr = bufnr })
  local attached = vim.tbl_filter(function(c) return c.attached_buffers[bufnr] end, active)
  if #attached > 0 then return end

  setup_autocommands(client, bufnr)
  setup_mappings(client)
  -- Lsp tagfunc is now set by default - surprise, surprise it does not play
  -- good with solargraph
  vim.bo[bufnr].tagfunc = nil
end

gh.augroup('LspSetupCommands', {
  {
    event = 'LspAttach',
    desc = 'setup the language server autocommands',
    command = function(args)
      local bufnr = args.buf
      -- if the buffer is invalid we should not try and attach to it
      if not api.nvim_buf_is_valid(args.buf) then return end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  },
})
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
    if not api.nvim_buf_is_valid(0) then return end
    vim.diagnostic.setqflist({ open = false })
    gh.toggle_list('quickfix')
    if not gh.is_vim_list_open() and cmd_id then
      api.nvim_del_autocmd(cmd_id)
      cmd_id = nil
    end
    if cmd_id then return end
    cmd_id = api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        if gh.is_vim_list_open() then
          vim.diagnostic.setqflist({ open = false })
          if #vim.fn.getqflist() == 0 then gh.toggle_list('quickfix') end
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
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function() return lvl == 'ERROR' or lvl == 'WARN' end,
  })
end
