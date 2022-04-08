gh.lsp = {}

--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function setup_autocommands(client, bufnr)
  if client and client.resolved_capabilities.document_highlight then
    local group = augroup('LspDocumentHiglight', { clear = false })
    vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
    autocmd({ 'CursorHold' }, {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })

    autocmd({ 'CursorMoved' }, {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end

  if client and client.supports_method 'textDocument/formatting' then
    local group = augroup('LspFormatting', { clear = false })
    vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
    autocmd({ 'BufWritePost' }, {
      group = group,
      buffer = bufnr,
      callback = function()
        gh.lsp.formatting(vim.fn.expand '<abuf>')
      end,
    })
  end
end
--------------------------------------------------------------------------------
---- Formatting
--------------------------------------------------------------------------------
-- use lsp formatting if it's available (and if it's good)
-- otherwise, fall back to null-ls
gh.lsp.formatting = function(bufnr)
  local preferred_formatting_clients = { 'eslint' }
  local fallback_formatting_client = 'null-ls'
  -- prevent repeated lookups
  local buffer_client_ids = {}

  bufnr = tonumber(bufnr) or vim.api.nvim_get_current_buf()

  local selected_client
  if buffer_client_ids[bufnr] then
    selected_client = vim.lsp.get_client_by_id(buffer_client_ids[bufnr])
  else
    for _, client in pairs(vim.lsp.buf_get_clients(bufnr)) do
      if vim.tbl_contains(preferred_formatting_clients, client.name) then
        selected_client = client
        break
      end

      if client.name == fallback_formatting_client then
        selected_client = client
      end
    end
  end

  if not selected_client then
    return
  end

  buffer_client_ids[bufnr] = selected_client.id

  local params = vim.lsp.util.make_formatting_params()
  selected_client.request('textDocument/formatting', params, function(err, res)
    if err then
      local err_msg = type(err) == 'string' and err or err.message
      vim.notify('global.lsp.formatting: ' .. err_msg, vim.log.levels.WARN)
      return
    end

    if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, 'modified') then
      return
    end

    if res then
      vim.lsp.util.apply_text_edits(res, bufnr, selected_client.offset_encoding or 'utf-16')
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd 'silent noautocmd update'
      end)
    end
  end, bufnr)
end
--------------------------------------------------------------------------------
---- Mappings
--------------------------------------------------------------------------------
---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
---@param bufnr integer?
local function setup_mappings(client, bufnr)
  gh.nnoremap('<leader>ld', vim.lsp.buf.definition)
  gh.nnoremap('<leader>lr', vim.lsp.buf.references)
  gh.nnoremap('<leader>lh', vim.lsp.buf.hover)
  gh.inoremap('<C-h>', vim.lsp.buf.signature_help)

  gh.nnoremap('[d', function()
    vim.diagnostic.goto_prev()
  end)

  gh.nnoremap(']d', function()
    vim.diagnostic.goto_next()
  end)

  if client.supports_method 'textDocument/codeAction' then
    gh.nnoremap('<leader>la', vim.lsp.buf.code_action)
  end

  if client.supports_method 'textDocument/rename' then
    gh.nnoremap('<leader>ln', vim.lsp.buf.rename)
  end

  if client.supports_method 'textDocument/formatting' then
    gh.nnoremap('<leader>lf', vim.lsp.buf.formatting)
  end
end

function gh.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
end
--------------------------------------------------------------------------------
---- Language servers
--------------------------------------------------------------------------------
----- LSP server configs are setup dynamically as they need to be generated during
----- startup so things like runtimepath for lua is correctly populated
gh.lsp.servers = {
  sumneko_lua = function()
    local ok, lua_dev = gh.safe_require 'lua-dev'
    if not ok then
      return {}
    end

    local lua_lsp_path = '/Users/pawelborak/language-servers/lua-language-server'
    return lua_dev.setup {
      lspconfig = {
        settings = {
          Lua = {
            completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
          },
        },
        cmd = {
          lua_lsp_path .. '/bin/macOS/lua-language-server',
          '-E',
          '-e',
          'LANG=en',
          lua_lsp_path .. '/main.lua',
        },
      },
    }
  end,

  solargraph = {},

  tsserver = {},
}

---Logic to merge default config with custom config coming from gh.lsp.servers
function gh.lsp.build_server_config(conf)
  local nvim_lsp_ok, cmp_nvim_lsp = gh.safe_require 'cmp_nvim_lsp'
  local conf_type = type(conf)
  local config = conf_type == 'table' and conf or conf_type == 'function' and conf() or {}
  config.flags = { debounce_text_changes = 500 }
  config.on_attach = gh.lsp.on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  return config
end

return function()
  local lspconfig = require 'lspconfig'
  for server, custom_config in pairs(gh.lsp.servers) do
    lspconfig[server].setup(gh.lsp.build_server_config(custom_config))
  end
end
