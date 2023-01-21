local smart_close_filetypes = {
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
}

local function smart_close()
  if vim.fn.winnr('$') ~= 1 then vim.api.nvim_win_close(0, true) end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    local is_unmapped = vim.fn.hasmapto('q', 'n') == 0

    local is_eligible = is_unmapped
      or vim.wo.previewwindow
      or vim.tbl_contains(smart_close_filetypes, vim.bo.filetype)

    if is_eligible then gh.nnoremap('q', smart_close, { buffer = 0, nowait = true }) end
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
  'TelescopePrompt',
}

---Set or unset the color column depending on the filetype of the buffer and its eligibility
local function check_color_column()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buffer = vim.bo[vim.api.nvim_win_get_buf(win)]
    local window = vim.wo[win]
    local is_current = win == vim.api.nvim_get_current_win()
    if gh.empty(vim.fn.win_gettype()) and not vim.tbl_contains(column_exclude, buffer.filetype) then
      local too_small = vim.api.nvim_win_get_width(win) <= buffer.textwidth + 1
      local is_excluded = vim.tbl_contains(column_block_list, buffer.filetype)
      if is_excluded or too_small then
        window.colorcolumn = ''
      elseif gh.empty(window.colorcolumn) and is_current then
        window.colorcolumn = '+1'
      end
    end
  end
end

vim.api.nvim_create_autocmd(
  { 'BufEnter', 'WinNew', 'WinClosed', 'FileType', 'VimResized' },
  { callback = check_color_column }
)

local cursorline_exclude = { 'toggleterm' }

---@param buf number
---@return boolean
local function should_show_cursorline(buf)
  return vim.bo[buf].buftype ~= 'terminal'
    and not vim.wo.previewwindow
    and vim.wo.winhighlight == ''
    and vim.bo[buf].filetype ~= ''
    and not vim.tbl_contains(cursorline_exclude, vim.bo[buf].filetype)
end

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(args) vim.wo.cursorline = should_show_cursorline(args.buf) end,
})

vim.api.nvim_create_autocmd('BufLeave', { callback = function() vim.wo.cursorline = false end })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase' },
  command = 'set bufhidden=delete',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'qf' },
  command = 'wincmd J',
})

vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*',
  callback = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '<buffer>',
      once = true,
      callback = function()
        vim.cmd(
          [[if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif]]
        )
      end,
    })
  end,
})
