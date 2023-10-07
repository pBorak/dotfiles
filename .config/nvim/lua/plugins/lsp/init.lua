return {

  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = function()
      return {
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = false,
            },
          },
        },
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
          solargraph = {
            mason = false,
          },
          tsserver = {},
          eslint = {
            root_dir = require('lspconfig').util.root_pattern(
              '.eslintrc',
              '.eslintrc.js',
              '.eslintrc.json'
            ),
          },
          dockerls = {},
          yamlls = {},
          jsonls = {},
          bashls = {},
          cssls = {},
          html = {},
        },
      }
    end,
    config = function(_, opts)
      require('plugins.lsp.diagnostics').setup()
      require('plugins.lsp.handlers').setup()
      require('plugins.lsp.autoformat').setup()

      require('util').on_lsp_attach(function(client, buffer)
        require('plugins.lsp.highlights').on_attach(client, buffer)
        require('plugins.lsp.keymaps').on_attach(client, buffer)
        vim.bo[buffer].tagfunc = nil
        vim.bo[buffer].formatexpr = nil
      end)

      local servers = opts.servers
      local capabilities =
        require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require('lspconfig')[server].setup(server_opts)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false
          if server_opts.mason == false then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require('mason-lspconfig').setup({ ensure_installed = ensure_installed })
      require('mason-lspconfig').setup_handlers({ setup })
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
        function() require('conform').format({ async = true, lsp_fallback = true }) end,
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },
}
