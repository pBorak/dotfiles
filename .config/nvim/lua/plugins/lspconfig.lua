gh.lsp = {}
--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local function setup_autocommands(client, _)
  if client and client.resolved_capabilities.document_highlight then
    gh.augroup('LspCursorCommands', {
      {
        events = { 'CursorHold' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { 'CursorHoldI' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.document_highlight,
      },
      {
        events = { 'CursorMoved' },
        targets = { '<buffer>' },
        command = vim.lsp.buf.clear_references,
      },
    }, { buffer = true })
  end

  if client and client.resolved_capabilities.document_formatting then
    gh.augroup('LspFormat', {
      {
        events = { 'BufWritePre' },
        targets = { '<buffer>' },
        command = gh.lsp.formatting,
      },
    }, { buffer = true })
  end
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
    vim.diagnostic.goto_prev {
      float = {
        border = 'rounded',
        focusable = false,
        source = 'always',
      },
    }
  end)

  gh.nnoremap(']d', function()
    vim.diagnostic.goto_next {
      float = {
        border = 'rounded',
        focusable = false,
        source = 'always',
      },
    }
  end)

  if client.supports_method 'textDocument/codeAction' then
    gh.nnoremap('<leader>la', vim.lsp.buf.code_action)
  end

  if client.supports_method 'textDocument/rename' then
    gh.nnoremap('<leader>ln', vim.lsp.buf.rename)
  end

  if client.resolved_capabilities.document_formatting then
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
