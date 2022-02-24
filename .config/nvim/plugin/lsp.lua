local lsp = vim.lsp
local fn = vim.fn
local fmt = string.format
local api = vim.api

--------------------------------------------------------------------------------
---- Commands
--------------------------------------------------------------------------------
local command = gh.command

command {
  'LspLog',
  function()
    vim.cmd('edit ' .. vim.lsp.get_log_path())
  end,
}

command {
  'LspDiagnostics',
  function()
    vim.diagnostic.setqflist { open = false }
    gh.toggle_list 'quickfix'
    if gh.is_vim_list_open() then
      gh.augroup('LspDiagnosticUpdate', {
        {
          events = { 'DiagnosticChanged' },
          targets = { '*' },
          command = function()
            if gh.is_vim_list_open() then
              gh.toggle_list 'quickfix'
            end
          end,
        },
      })
    elseif fn.exists '#LspDiagnosticUpdate' > 0 then
      vim.cmd 'autocmd! LspDiagnosticUpdate'
    end
  end,
}
gh.nnoremap('<leader>ll', '<Cmd>LspDiagnostics<CR>')
--------------------------------------------------------------------------------
---- Signs
--------------------------------------------------------------------------------
local diagnostic_types = {
  { 'Hint', icon = gh.style.icons.hint },
  { 'Error', icon = gh.style.icons.error },
  { 'Warn', icon = gh.style.icons.warn },
  { 'Info', icon = gh.style.icons.info },
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

---Override diagnostics signs helper to only show the single most relevant sign
---@param diagnostics table[]
---@param _ number buffer number
---@return table[]
local function filter_diagnostics(diagnostics, _)
  if not diagnostics then
    return {}
  end
  -- Work out max severity diagnostic per line
  local max_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    local lnum = d.lnum
    if max_severity_per_line[lnum] then
      local current_d = max_severity_per_line[lnum]
      if d.severity < current_d.severity then
        max_severity_per_line[lnum] = d
      end
    else
      max_severity_per_line[lnum] = d
    end
  end

  -- map to list
  local filtered_diagnostics = {}
  for _, v in pairs(max_severity_per_line) do
    table.insert(filtered_diagnostics, v)
  end
  return filtered_diagnostics
end

--- This overwrites the diagnostic show/set_signs function to replace it with a custom function
--- that restricts nvim's diagnostic signs to only the single most severe one per line
local ns = api.nvim_create_namespace 'severe-diagnostics'
local show = vim.diagnostic.show
local function display_signs(bufnr)
  -- Get all diagnostics from the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)
  local filtered = filter_diagnostics(diagnostics, bufnr)
  show(ns, bufnr, filtered, {
    virtual_text = false,
    underline = false,
    signs = true,
  })
end

function vim.diagnostic.show(namespace, bufnr, ...)
  show(namespace, bufnr, ...)
  display_signs(bufnr)
end
-----------------------------------------------------------------------------//
-- LSP Progress notification
-----------------------------------------------------------------------------//
local client_notifs = {}

local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

local function update_spinner(client_id, token)
  local notif_data = client_notifs[client_id][token]
  if notif_data and notif_data.spinner then
    local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    local new_notif = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[new_spinner],
      replace = notif_data.notification,
    })
    client_notifs[client_id][token] = {
      notification = new_notif,
      spinner = new_spinner,
    }
    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client)
  return client.name .. (#title > 0 and ': ' .. title or '')
end

local function format_message(message, percentage)
  return (percentage and percentage .. '%\t' or '') .. (message or '')
end

local function lsp_progress_notification(_, result, ctx)
  local client_id = ctx.client_id
  local val = result.value
  if val.kind then
    if not client_notifs[client_id] then
      client_notifs[client_id] = {}
    end
    local notif_data = client_notifs[client_id][result.token]
    if val.kind == 'begin' then
      local message = format_message(val.message, val.percentage)
      local notification = vim.notify(message, 'info', {
        title = format_title(val.title, vim.lsp.get_client_by_id(client_id)),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = true,
      })
      client_notifs[client_id][result.token] = {
        notification = notification,
        spinner = 1,
      }
      update_spinner(client_id, result.token)
    elseif val.kind == 'report' and notif_data then
      local new_notif = vim.notify(
        format_message(val.message, val.percentage),
        'info',
        { replace = notif_data.notification, hide_from_history = false }
      )
      client_notifs[client_id][result.token] = {
        notification = new_notif,
        spinner = notif_data.spinner,
      }
    elseif val.kind == 'end' and notif_data then
      local new_notif = vim.notify(
        val.message and format_message(val.message) or 'Complete',
        'info',
        { icon = '', replace = notif_data.notification, timeout = 3000 }
      )
      client_notifs[client_id][result.token] = {
        notification = new_notif,
      }
    end
  end
end
--------------------------------------------------------------------------------
---- Handler overrides
--------------------------------------------------------------------------------
vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  signs = false,
  update_in_insert = false,
  severity_sort = true,
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

lsp.handlers['$/progress'] = lsp_progress_notification
