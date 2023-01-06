---@diagnostic disable: undefined-global
--
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
      t({ keyword .. arg }),
      t({ '', '' }),
      t({ string.rep('\t', index) }),
    })
  end

  vim.list_extend(nodes, {
    i(1),
  })

  for index, _ in ipairs(classified_parts) do
    vim.list_extend(nodes, {
      t({ '', '' }),
      t({ string.rep('\t', arguments_size - index) }),
      t({ 'end' }),
    })
  end

  return sn(nil, nodes)
end

local function assign_instance_variables(args, _, _)
  local nodes = {}
  local args_table = vim.split(args[1][1], ',', true)

  for index, arg in ipairs(args_table) do
    arg = arg:gsub(' ', '')

    if arg and arg:match('^%a') then
      local stripped_arg = arg:match(ruby_args_pattern)
      if index > 1 then vim.list_extend(nodes, {
        t({ '', '\t' }),
      }) end
      vim.list_extend(nodes, {
        t({ '@' .. stripped_arg .. ' = ' .. stripped_arg }),
      })
    end
  end

  return sn(nil, nodes)
end

return {
  snippet(
    {
      trig = 'spec',
      name = 'rspec spec init',
      dscr = { 'Initialize rspec file' },
    },
    fmt(
      [[
            # frozen_string_literal: true

            require "spec_helper"

            describe {} do
              {}
            end
        ]],
      {
        f(function(_, snip)
          local file_path = snip.env.RELATIVE_FILEPATH
          return spec_name(file_path)
        end, {}),
        i(0),
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
        i(1),
        d(2, assign_instance_variables, { 1 }),
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
            def self.call(...)
              new(...).call
            end

            def initialize({})
              {}
            end

            def call
              {}
            end
        ]],
      {
        i(1),
        d(2, assign_instance_variables, { 1 }),
        i(0),
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
      d(1, function(_, snip)
        local file_path = snip.env.RELATIVE_FILEPATH
        return ruby_class(file_path)
      end, {})
    )
  ),
}
