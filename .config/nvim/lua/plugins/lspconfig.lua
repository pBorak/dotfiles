return function()
  if vim.g.lsp_config_complete then return end
  vim.g.lsp_config_complete = true

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
    solargraph = true,
    tsserver = true,
    eslint = true,
    dockerls = true,
  }
  require('nvim-lsp-installer').setup({
    automatic_installation = { exclude = { 'solargraph' } },
  })

  for name, config in pairs(servers) do
    if type(config) == 'boolean' then
      config = {}
    elseif config and type(config) == 'function' then
      config = config()
    end
    if config then
      config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = gh.safe_require('cmp_nvim_lsp')
      if ok then cmp_nvim_lsp.update_capabilities(config.capabilities) end
      require('lspconfig')[name].setup(config)
    end
  end
end
