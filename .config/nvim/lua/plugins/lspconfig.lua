gh.lsp = {}

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
            format = { enable = false },
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
