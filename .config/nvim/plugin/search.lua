_G._search = {}
local is_toggle = false
local mode = 'term'
local last_search = ''

local function unmap(map_mode, lhs)
  return vim.api.nvim_del_keymap(map_mode, lhs)
end

gh.augroup('InitVimSearch', {
  {
    events = { 'FileType' },
    targets = { 'qf' },
    command = function()
      gh.nnoremap('<leader>r', ':cgetexpr v:lua._search.do_search()<CR>', { buffer = 0 })
    end,
  },
})

gh.nnoremap('<leader>s', ':call v:lua._search.run("")<CR>')
gh.nnoremap('<leader>S', ':call v:lua._search.run(expand("<cword>"))<CR>')
gh.vnoremap('<leader>S', ':<C-u>call v:lua._search.run("", 1)<CR>')

local function cleanup(no_reset_mode)
  is_toggle = false
  if not no_reset_mode then
    mode = 'term'
  end
  return pcall(unmap, 'c', '<tab>')
end

local function get_visual_selection()
  local s_start = vim.fn.getpos "'<"
  local s_end = vim.fn.getpos "'>"
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

local function msg(txt)
  return vim.api.nvim_out_write(txt .. '\n')
end

function _search.toggle_search_mode()
  is_toggle = true
  mode = mode == 'regex' and 'term' or 'regex'

  return vim.fn.getcmdline()
end

function _search.run(search_term, is_visual)
  local term = search_term
  if is_visual then
    term = get_visual_selection()
  end

  gh.cmap('<tab>', '<C-\\>ev:lua._search.toggle_search_mode()<CR><CR>', { noremap = false })

  local status, t = pcall(vim.fn.input, 'Enter ' .. mode .. ': ', term)
  if not status then
    return cleanup()
  end
  term = t

  if is_toggle then
    is_toggle = false
    return _search.run(term)
  end

  cleanup 'no_reset_mode'
  vim.cmd [[redraw!]]

  if term == '' then
    return msg 'Empty search.'
  end

  msg('Searching for word -> ' .. term)
  local status_dir, dir = pcall(vim.fn.input, 'Path: ', '', 'file')
  if not status_dir then
    return cleanup()
  end

  local grepprg = vim.o.grepprg
  local cmd = nil
  if mode == 'term' then
    cmd = table.concat({ grepprg, '--fixed-strings', vim.fn.shellescape(term), dir }, ' ')
  else
    cmd = table.concat({ grepprg, term, dir }, ' ')
  end

  if (not cmd or cmd == '') and last_search == '' then
    msg 'Empty search.'
    return cleanup()
  end

  cmd = cmd and cmd ~= '' and cmd or last_search
  last_search = cmd

  local results = vim.fn.systemlist(cmd)

  if #results <= 0 then
    msg('No results for search -> ' .. cmd)
    return cleanup()
  end

  if vim.v.shell_error and vim.v.shell_error > 0 and #results > 0 then
    msg('Search error (status: ' .. vim.v.shell_error .. '): ' .. table.concat(results, ' '))
    return cleanup()
  end

  vim.cmd [[botright cgetexpr v:lua._search.do_search()]]
  return cleanup()
end

function _search.do_search()
  return vim.fn.systemlist(last_search)
end
