return function()
  local ls = require 'luasnip'
  local types = require 'luasnip.util.types'
  local fmt = require('luasnip.extras.fmt').fmt

  local snippet = ls.snippet
  local t_node = ls.text_node
  local f_node = ls.function_node
  local i_node = ls.insert_node
  local d_node = ls.dynamic_node
  local c_node = ls.choice_node
  local snip_node = ls.snippet_node
  local ruby_args_pattern = '^%a[^=:,]*'

  local function split_path(path)
    local parts = vim.fn.split(path, '/')
    local root = parts[1]

    if root == 'app' then
      return { unpack(parts, 3) }
    elseif root == 'spec' then
      parts[#parts] = parts[#parts]:gsub('_spec', '')
      return { unpack(parts, 3) }
    elseif root == 'lib' then
      return { unpack(parts, 2, #parts) }
    else
      return parts
    end
  end

  local function classify_path_parts(path)
    local parts = split_path(path:gsub('.rb', ''))

    local result = {}
    for k, v in pairs(parts) do
      result[k] = v:gsub('_(.)', string.upper):gsub('^%l', string.upper)
    end
    return result
  end

  local function spec_name(path)
    local classified_parts = classify_path_parts(path)

    return table.concat(classified_parts, '::')
  end

  local function ruby_class(path)
    local classified_parts = classify_path_parts(path)
    local arguments_size = #classified_parts
    local nodes = {}

    for index, arg in ipairs(classified_parts) do
      local keyword = index == arguments_size and 'class ' or 'module '

      vim.list_extend(nodes, {
        t_node { keyword .. arg },
        t_node { '', '' },
        t_node { string.rep('\t', index) },
      })
    end

    vim.list_extend(nodes, {
      i_node(1),
    })

    for index, _ in ipairs(classified_parts) do
      vim.list_extend(nodes, {
        t_node { '', '' },
        t_node { string.rep('\t', arguments_size - index) },
        t_node { 'end' },
      })
    end

    return snip_node(nil, nodes)
  end

  local function assign_instance_variables(args, _, _)
    local nodes = {}
    local args_table = vim.split(args[1][1], ',', true)

    for index, arg in ipairs(args_table) do
      arg = arg:gsub(' ', '')

      if arg and arg:match '^%a' then
        local stripped_arg = arg:match(ruby_args_pattern)
        if index > 1 then
          vim.list_extend(nodes, {
            t_node { '', '\t' },
          })
        end
        vim.list_extend(nodes, {
          t_node { '@' .. stripped_arg .. ' = ' .. stripped_arg },
        })
      end
    end

    return snip_node(nil, nodes)
  end

  local function pass_ruby_args(args, _, _, opts)
    local nodes = {}
    local args_table = vim.split(args[1][1], ',', true)

    for _, arg in ipairs(args_table) do
      arg = arg:gsub(' ', '')

      if arg and arg:match '^%a' then
        local stripped_arg = arg:match(ruby_args_pattern)
        local node = opts == 'keyword_args' and t_node { stripped_arg .. ':' }
          or t_node { stripped_arg .. ': ' .. stripped_arg }

        vim.list_extend(nodes, { node, t_node { ', ' } })
      end
    end

    -- Hack to remove last floating semicolon
    table.remove(nodes)

    return snip_node(nil, nodes)
  end

  ls.config.set_config {
    history = false,
    updateevents = 'TextChangedI',
    region_check_events = 'CursorMoved,CursorHold,InsertEnter',
    delete_check_events = 'InsertLeave',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '●', 'Operator' } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { '●', 'Type' } },
        },
      },
    },
    enable_autosnippets = true,
  }
  -- <c-l> is selecting within a list of options.
  vim.keymap.set('i', '<c-l>', function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-j>', function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)

  vim.keymap.set({ 's', 'i' }, '<c-k>', function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)

  ls.snippets = {
    all = {
      snippet({ trig = 'td', name = 'TODO' }, {
        c_node(1, {
          t_node 'TODO: ',
          t_node 'FIXME: ',
          t_node 'HACK: ',
          t_node 'BUG: ',
        }),
        i_node(0),
      }),
    },
    ruby = {
      snippet(
        {
          trig = 'spec',
          name = 'rspec spec init',
          dscr = { 'Initialize rspec file' },
        },
        fmt(
          [[
            # frozen_string_literal: true

            require 'spec_helper'

            describe {} do
              {}
            end
        ]],
          {
            f_node(function(_, snip)
              local file_path = snip.env.RELATIVE_FILEPATH
              return spec_name(file_path)
            end, {}),
            i_node(0),
          }
        )
      ),
      snippet(
        {
          trig = 'init',
          name = 'Ruby `initialize` method',
          dscr = { 'Ruby initialize function' },
        },
        fmt(
          [[
            def initialize({})
              {}
            end
          ]],
          {
            i_node(1),
            d_node(2, assign_instance_variables, { 1 }),
          }
        )
      ),
      snippet(
        {
          trig = 'scall',
          name = 'Ruby `self.call` method',
          dscr = { 'Ruby self.call function boilerplate' },
        },
        fmt(
          [[
            def self.call({})
              new({}).call
            end

            def initialize({})
              {}
            end

            def call
              {}
            end
        ]],
          {
            i_node(1),
            d_node(2, pass_ruby_args, { 1 }),
            d_node(3, pass_ruby_args, { 1 }, { user_args = { 'keyword_args' } }),
            d_node(4, assign_instance_variables, { 1 }),
            i_node(0),
          }
        )
      ),
      snippet(
        {
          trig = 'class',
          name = 'ruby class',
          dscr = { 'Init Ruby class and modules based on the path' },
        },
        fmt(
          [[
            # frozen_string_literal: true

            {}
          ]],
          d_node(1, function(_, snip)
            local file_path = snip.env.RELATIVE_FILEPATH
            return ruby_class(file_path)
          end, {})
        )
      ),
    },
  }

  require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets' }
end
