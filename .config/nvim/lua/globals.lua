local fn = vim.fn
local api = vim.api
local fmt = string.format
--------------------------------------------------------------------------------
-- Global namespace
--------------------------------------------------------------------------------
_G.__as_global_callbacks = __as_global_callbacks or {}

_G.gh = {
  _store = __as_global_callbacks,
  mappings = {},
}

-- inject mapping helpers into the global namespace
R 'utils.mappings'
--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------
do
  gh.style = {
    icons = {
      error = '✗',
      warn = '',
      info = '',
      hint = '',
    },
    lsp = {
      kinds = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = '',
        Interface = '',
        Module = '',
        Property = 'ﰠ',
        Unit = '塞',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = 'פּ',
        Event = '',
        Operator = '',
        TypeParameter = '',
      },
    },
  }
end
--------------------------------------------------------------------------------
-- Debugging
--------------------------------------------------------------------------------
-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- @see: https://www.reddit.com/r/neovim/comments/p84iu2/useful_functions_to_explore_lua_objects/
-- USAGE:
-- in lua: P({1, 2, 3})
-- in commandline: :lua P(vim.loop)
---@vararg any
function P(...)
  local objects, v = {}, nil
  for i = 1, select('#', ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function gh.plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/opt/*', true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return fn.fnamemodify(path, ':t')
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end
--------------------------------------------------------------------------------
-- Utils
--------------------------------------------------------------------------------
---Check whether or not the location or quickfix list is open
---@return boolean
function gh.is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == 'qf' or is_loc_list then
      return true
    end
  end
  return false
end

function gh._create(f)
  table.insert(gh._store, f)
  return #gh._store
end

function gh._execute(id, args)
  gh._store[id](args)
end

---@class Autocommand
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
function gh.augroup(name, commands)
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = id,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
function gh.source(path, prefix)
  if not prefix then
    vim.cmd(fmt('source %s', path))
  else
    vim.cmd(fmt('source %s/%s', vim.g.vim_dir, path))
  end
end

---require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function gh.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, vim.log.levels.ERROR, { title = fmt('error requiring: %s', module) })
  end
  return ok, result
end

---Check if a cmd is executable
---@param e string
---@return boolean
function gh.executable(e)
  return fn.executable(e) > 0
end

---@param name any
---@param rhs string|fun(args: string, fargs: table, bang: boolean)
---@param opts table
function gh.command(name, rhs, opts)
  opts = opts or {}
  api.nvim_add_user_command(name, rhs, opts)
end

function gh.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= '_G' and value and fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end
