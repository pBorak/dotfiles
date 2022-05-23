local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local api = vim.api
local icons = gh.style.icons.lsp

--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local highligh_ag = augroup('LspDocumentHiglight', {})
local formatting_ag = augroup('LspDocumentFormat', {})

local format_exclusions = { 'sumneko_lua' }

local function formatting_filter(clients)
  return vim.tbl_filter(function(c)
    return not vim.tbl_contains(format_exclusions, c.name)
  end, clients)
end

local function setup_autocommands(client, bufnr)
  if client and client.supports_method 'textDocument/documentHighlight' then
    vim.api.nvim_clear_autocmds { group = highligh_ag, buffer = bufnr }
    autocmd({ 'CursorHold' }, {
      group = highligh_ag,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })

    autocmd({ 'CursorMoved' }, {
      group = highligh_ag,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
  if
    client
    and client.server_capabilities.documentFormattingProvider
    and not vim.tbl_contains({ 'ruby' }, vim.bo[bufnr].filetype)
  then
    vim.api.nvim_clear_autocmds { group = formatting_ag, buffer = bufnr }
    autocmd({ 'BufWritePre' }, {
      group = highligh_ag,
      buffer = bufnr,
      callback = function()
        if fn.bufloaded(bufnr) then
          vim.lsp.buf.format {
            bufnr = bufnr,
            filter = formatting_filter,
          }
        end
      end,
    })
  end
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

  gh.nnoremap('[d', function()
    vim.diagnostic.goto_prev()
  end)
  gh.nnoremap(']d', function()
    vim.diagnostic.goto_next()
  end)
end
-----------------------------------------------------------------------------//
-- Lsp setup/teardown
-----------------------------------------------------------------------------//
---Add buffer local mappings, autocommands, tagfunc etc for attaching servers
---@param client table lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client)
end

gh.augroup('LspSetupCommands', {
  {
    event = 'LspAttach',
    desc = 'setup the language server autocommands',
    command = function(args)
      local bufnr = args.buf
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
    if not api.nvim_buf_is_valid(0) then
      return
    end
    vim.diagnostic.setqflist { open = false }
    gh.toggle_list 'quickfix'
    if not gh.is_vim_list_open() and cmd_id then
      api.nvim_del_autocmd(cmd_id)
      cmd_id = nil
    end
    if cmd_id then
      return
    end
    cmd_id = api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        if gh.is_vim_list_open() then
          vim.diagnostic.setqflist { open = false }
          if #vim.fn.getqflist() == 0 then
            gh.toggle_list 'quickfix'
          end
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

local ns = api.nvim_create_namespace 'severe-diagnostics'

local function max_diagnostic(callback)
  return function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr)
    signs_handler.hide(ns, bufnr)
  end,
}

local virt_text_handler = vim.diagnostic.handlers.virtual_text
vim.diagnostic.handlers.virtual_text = {
  show = max_diagnostic(virt_text_handler.show),
  hide = function(_, bufnr)
    virt_text_handler.hide(ns, bufnr)
  end,
}

vim.diagnostic.config {
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
}

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
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end
