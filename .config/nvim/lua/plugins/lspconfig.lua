gh.lsp = {}

--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local highligh_ag = augroup('LspDocumentHiglight', {})

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
    gh.nnoremap('<leader>lf', vim.lsp.buf.format)
  end
end

function gh.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
  local format_ok, lsp_format = pcall(require, 'lsp-format')
  if format_ok then
    lsp_format.on_attach(client)
  end
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

    return lua_dev.setup {
      lspconfig = {
        settings = {
          Lua = {
            completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
          },
        },
      },
    }
  end,
  solargraph = true,
  tsserver = true,
}

---Logic to merge default config with custom config coming from gh.lsp.servers
function gh.lsp.build_server_config(conf)
  local conf_type = type(conf)
  local config = conf_type == 'table' and conf or conf_type == 'function' and conf() or {}
  config.on_attach = config.on_attach or gh.lsp.on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  local nvim_lsp_ok, cmp_nvim_lsp = gh.safe_require 'cmp_nvim_lsp'
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  return config
end

return function()
  require('nvim-lsp-installer').setup {
    automatic_installation = { exclude = { 'solargraph' } },
  }
  if vim.v.vim_did_enter == 1 then
    return
  end
  for server, custom_config in pairs(gh.lsp.servers) do
    require('lspconfig')[server].setup(gh.lsp.build_server_config(custom_config))
  end
end
