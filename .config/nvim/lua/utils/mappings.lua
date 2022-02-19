-- MAPPINGS
local fmt = string.format

---check if a mapping already exists
---@param lhs string
---@param mode string
---@return boolean
function gh.has_map(lhs, mode)
  mode = mode or 'n'
  return vim.fn.maparg(lhs, mode) ~= ''
end

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    assert(lhs ~= mode, fmt('The lhs should not be the same as mode for %s', lhs))
    assert(type(rhs) == 'string' or type(rhs) == 'function', '"rhs" should be a function or string')
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { label = opts } or opts and vim.deepcopy(opts) or {}
    opts = vim.tbl_extend('keep', opts, parent_opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local map_opts = { remap = true, silent = true }
local noremap_opts = { remap = false, silent = true }

-- A recursive commandline mapping
gh.nmap = make_mapper('n', map_opts)
-- A recursive terminal mapping
gh.imap = make_mapper('i', map_opts)
-- A recursive normal mapping
gh.cmap = make_mapper('c', { noremap = false, silent = false })
-- A non recursive normal mapping
gh.nnoremap = make_mapper('n', noremap_opts)
-- A non recursive visual mapping
gh.xnoremap = make_mapper('x', noremap_opts)
-- A non recursive visual & select mapping
gh.vnoremap = make_mapper('v', noremap_opts)
-- A non recursive insert mapping
gh.inoremap = make_mapper('i', noremap_opts)
-- A non recursive operator mapping
gh.onoremap = make_mapper('o', noremap_opts)
-- A non recursive terminal mapping
gh.tnoremap = make_mapper('t', noremap_opts)
-- A non recursive select mapping
gh.snoremap = make_mapper('s', noremap_opts)
-- A non recursive commandline mapping
gh.cnoremap = make_mapper('c', { noremap = true, silent = false })

---Factory function to create multi mode map functions
---e.g. `gh.map({"n", "s"}, lhs, rhs, opts)`
---@param target string
---@return fun(modes: string[], lhs: string, rhs: string, opts: table)
local function multimap(target)
  return function(modes, lhs, rhs, opts)
    for _, m in ipairs(modes) do
      gh[m .. target](lhs, rhs, opts)
    end
  end
end

gh.map = multimap 'map'
gh.noremap = multimap 'noremap'
