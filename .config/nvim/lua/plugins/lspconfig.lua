--------------------------------------------------------------------------------
---- Autocommands
--------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local highlight_ag = augroup('LspDocumentHiglight', {})
local formatting_ag = augroup('LspDocumentFormat', {})

local format_exclusions = { 'sumneko_lua', 'solargraph', 'dockerls' }

local function formatting_filter(client) return not vim.tbl_contains(format_exclusions, client.name) end

local function setup_autocommands(client, bufnr)
  if client and client.supports_method('textDocument/documentHighlight') then
    vim.api.nvim_clear_autocmds({ group = highlight_ag, buffer = bufnr })
    autocmd({ 'CursorHold' }, {
      group = highlight_ag,
      buffer = bufnr,
      desc = 'LSP: References',
      callback = function() vim.lsp.buf.document_highlight() end,
    })

    autocmd({ 'CursorMoved' }, {
      group = highlight_ag,
      buffer = bufnr,
      desc = 'LSP: References Clear',
      callback = function() vim.lsp.buf.clear_references() end,
    })
  end
  if client and client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_clear_autocmds({ group = formatting_ag, buffer = bufnr })
    autocmd({ 'BufWritePre' }, {
      group = formatting_ag,
      buffer = bufnr,
      desc = 'LSP: Format on save',
      callback = function(args)
        vim.lsp.buf.format({
          bufnr = args.bufnr,
          filter = formatting_filter,
        })
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

  gh.nnoremap('[d', function() vim.diagnostic.goto_prev() end)
  gh.nnoremap(']d', function() vim.diagnostic.goto_next() end)
end

---Add buffer local mappings, autocommands, tagfunc etc for attaching servers
---@param client table lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client)
  -- Lsp tagfunc is now set by default - surprise, surprise it does not play
  -- good with solargraph
  vim.bo[bufnr].tagfunc = nil
  vim.bo[bufnr].formatexpr = nil
end

--------------------------------------------------------------------------------
---- Language servers
--------------------------------------------------------------------------------
local servers = {
  sumneko_lua = function()
    return {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          format = { enable = false },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
          diagnostics = {
            globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'packer_plugins' },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,
  solargraph = function()
    return {
      root_dir = require('lspconfig').util.root_pattern('.git', 'Gemfile', '*.gemspec'),
    }
  end,
  tsserver = true,
  eslint = true,
  dockerls = true,
  yamlls = true,
  jsonls = true,
  bashls = true,
}
require('mason-lspconfig').setup({
  automatic_installation = { exclude = { 'solargraph' } },
})

for name, config in pairs(servers) do
  if type(config) == 'boolean' then
    config = {}
  elseif config and type(config) == 'function' then
    config = config()
  end
  if config then
    config.on_attach = on_attach
    config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = gh.safe_require('cmp_nvim_lsp')
    if ok then cmp_nvim_lsp.update_capabilities(config.capabilities) end
    require('lspconfig')[name].setup(config)
  end
end
