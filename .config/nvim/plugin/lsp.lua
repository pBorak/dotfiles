local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local api = vim.api
local icons = gh.style.icons.lsp

--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local features = {
  FORMATTING = 'formatting',
  DIAGNOSTICS = 'diagnostics',
  REFERENCES = 'references',
}
local get_augroup = function(bufnr, method)
  assert(bufnr, 'A bufnr is required to create an lsp augroup')
  return fmt('LspCommands_%d_%s', bufnr, method)
end

--- Check that a buffer is valid and loaded before calling a callback
---@param callback function
---@param buf integer
local function valid_call(callback, buf)
  if not buf or not api.nvim_buf_is_loaded(buf) or not api.nvim_buf_is_valid(buf) then return end
  callback()
end

local format_exclusions = { 'sumneko_lua', 'solargraph', 'dockerls' }

local function formatting_filter(client) return not vim.tbl_contains(format_exclusions, client.name) end

local function setup_autocommands(client, bufnr)
  if not client then
    local msg = fmt('Unable to setup LSP autocommands, client for %d is missing', bufnr)
    return vim.notify(msg, 'error', { title = 'LSP Setup' })
  end

  gh.augroup(get_augroup(bufnr, features.DIAGNOSTICS), {
    {
      event = { 'CursorHold' },
      buffer = bufnr,
      desc = 'LSP: Show diagnostics',
      command = function(args) vim.diagnostic.open_float(args.buf, { scope = 'cursor', focus = false }) end,
    },
  })

  if client.server_capabilities.documentFormattingProvider then
    gh.augroup(get_augroup(bufnr, features.FORMATTING), {
      {
        event = 'BufWritePre',
        buffer = bufnr,
        desc = 'LSP: Format on save',
        command = function(args)
          vim.lsp.buf.format({
            bufnr = args.bufnr,
            filter = formatting_filter,
          })
        end,
      },
    })
  end

  if client.server_capabilities.documentHighlightProvider then
    gh.augroup(get_augroup(bufnr, features.REFERENCES), {
      {
        event = { 'CursorHold', 'CursorHoldI' },
        buffer = bufnr,
        desc = 'LSP: References',
        command = function(args) valid_call(vim.lsp.buf.document_highlight, args.buf) end,
      },
      {
        event = 'CursorMoved',
        desc = 'LSP: References Clear',
        buffer = bufnr,
        command = function(args) valid_call(vim.lsp.buf.clear_references, args.buf) end,
      },
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
      if not api.nvim_buf_is_valid(args.buf) or not args.data then return end
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  },
  {
    event = 'LspDetach',
    desc = 'Clean up after detached LSP',
    command = function(args)
      -- Only clear autocommands if there are no other clients attached to the buffer
      if next(vim.lsp.get_active_clients({ bufnr = args.buf })) then return end
      gh.foreach(
        function(feature)
          pcall(api.nvim_clear_autocmds, {
            group = get_augroup(args.buf, feature),
            buffer = args.buf,
          })
        end,
        features
      )
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
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function() return lvl == 'ERROR' or lvl == 'WARN' end,
  })
end
