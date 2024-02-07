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
    'pmizio/typescript-tools.nvim',
    lazy = false,
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      local definition_handler =
        require('plugins.lsp.handlers').filter_definition_react_dtls_handler

      local handlers = {
        ['textDocument/definition'] = definition_handler,
      }

      require('typescript-tools').setup({
        handlers = handlers,
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'literal',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })
    end,
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
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },
}
