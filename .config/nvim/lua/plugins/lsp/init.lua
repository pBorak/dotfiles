return {

  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = function()
      return {
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                format = { enable = false },
                completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
                diagnostics = {
                  globals = { 'vim' },
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          },
          ruby_lsp = {},
          dockerls = {},
          yamlls = {},
          jsonls = {},
          bashls = {},
          cssls = {},
          html = {},
          vtsls = {},
        },
      }
    end,
    config = function(_, opts)
      require('plugins.lsp.diagnostics').setup()
      require('plugins.lsp.autoformat').setup()
      require('plugins.lsp.on_attach').setup()

      local servers = opts.servers
      local capabilities =
        require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require('lspconfig')[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          setup(server)
        end
      end
    end,
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    build = ':MasonUpdate',
    config = true,
  },

  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    event = 'BufWritePre',
    lazy = true,
    keys = {
      {
        '<leader>lf',
        function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },
}
