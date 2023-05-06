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
          vtsls = {},
          eslint = {
            root_dir = require('lspconfig').util.root_pattern(
              '.eslintrc',
              '.eslintrc.js',
              '.eslintrc.json'
            ),
            settings = {
              format = {
                enable = true,
              },
            },
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

      require('util').on_lsp_attach(function(client, buffer)
        require('plugins.lsp.format').on_attach(client, buffer)
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
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufReadPre',
    opts = function()
      local nls = require('null-ls')

      return {
        debounce = 150,
        sources = {
          nls.builtins.formatting.prettier.with({
            condition = function(_utils) return _utils.root_has_file('.prettierrc') end,
          }),
          nls.builtins.formatting.stylua,
        },
      }
    end,
  },
}
