local Util = require('util')

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'help',
    'git-status',
    'git-log',
    'gitcommit',
    'fugitive',
    'fugitiveblame',
    'qf',
    'startuptime',
    'lspinfo',
    'neotest-summary',
    'neotest-output',
    'neotest-attach',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      timeout = 500,
      on_visual = true,
      higroup = 'Visual',
    })
  end,
})

local column_exclude = { 'gitcommit' }
local column_block_list = {
  'DiffviewFileHistory',
  'help',
  'fugitive',
}

---Set or unset the color column depending on the filetype of the buffer and its eligibility
local function check_color_column()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buffer = vim.bo[vim.api.nvim_win_get_buf(win)]
    local window = vim.wo[win]
    local is_current = win == vim.api.nvim_get_current_win()
    if
      Util.empty(vim.fn.win_gettype()) and not vim.tbl_contains(column_exclude, buffer.filetype)
    then
      local too_small = vim.api.nvim_win_get_width(win) <= buffer.textwidth + 1
      local is_excluded = vim.tbl_contains(column_block_list, buffer.filetype)
      if is_excluded or too_small then
        window.colorcolumn = ''
      elseif Util.empty(window.colorcolumn) and is_current then
        window.colorcolumn = '+1'
      end
    end
  end
end

vim.api.nvim_create_autocmd(
  { 'BufEnter', 'WinNew', 'WinClosed', 'FileType', 'VimResized' },
  { callback = check_color_column }
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase' },
  command = 'set bufhidden=delete',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  command = 'wincmd J',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})
