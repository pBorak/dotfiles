return function()
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
      config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = gh.safe_require('cmp_nvim_lsp')
      if ok then cmp_nvim_lsp.update_capabilities(config.capabilities) end
      require('lspconfig')[name].setup(config)
    end
  end
end
