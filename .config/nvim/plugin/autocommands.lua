local fn = vim.fn
local api = vim.api
local contains = vim.tbl_contains

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
}

local function smart_close()
  if fn.winnr('$') ~= 1 then api.nvim_win_close(0, true) end
end

gh.augroup('SmartClose', {
  {
    -- Close certain filetypes by pressing q.
    event = 'FileType',
    pattern = '*',
    command = function()
      local is_unmapped = fn.hasmapto('q', 'n') == 0

      local is_eligible = is_unmapped
        or vim.wo.previewwindow
        or contains(smart_close_filetypes, vim.bo.filetype)

      if is_eligible then gh.nnoremap('q', smart_close, { buffer = 0, nowait = true }) end
    end,
  },
})

---@return function
local function clear_commandline()
  --- Track the timer object and stop any previous timers before setting
  --- a new one so that each change waits for 10secs and that 10secs is
  --- deferred each time
  local timer
  return function()
    if timer then timer:stop() end
    timer = vim.defer_fn(function()
      if fn.mode() == 'n' then vim.cmd.echon("''") end
    end, 10000)
  end
end

gh.augroup('ClearCommandMessages', {
  {
    event = { 'CmdlineLeave', 'CmdlineChanged' },
    pattern = { ':' },
    command = clear_commandline(),
  },
})

gh.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = 'TextYankPost',
    pattern = '*',
    command = function()
      vim.highlight.on_yank({
        timeout = 500,
        on_visual = true,
        higroup = 'Visual',
      })
    end,
  },
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
  for _, win in ipairs(api.nvim_list_wins()) do
    local buffer = vim.bo[api.nvim_win_get_buf(win)]
    local window = vim.wo[win]
    local is_current = win == api.nvim_get_current_win()
    if gh.empty(fn.win_gettype()) and not contains(column_exclude, buffer.filetype) then
      local too_small = api.nvim_win_get_width(win) <= buffer.textwidth + 1
      local is_excluded = contains(column_block_list, buffer.filetype)
      if is_excluded or too_small then
        window.colorcolumn = ''
      elseif gh.empty(window.colorcolumn) and is_current then
        window.colorcolumn = '+1'
      end
    end
  end
end

gh.augroup('CustomColorColumn', {
  {
    -- Update the cursor column to match current window size
    event = { 'BufEnter', 'WinNew', 'WinClosed', 'FileType', 'VimResized' },
    command = check_color_column,
  },
})

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

gh.augroup('Cursorline', {
  {
    event = { 'BufEnter' },
    pattern = { '*' },
    command = function(args) vim.wo.cursorline = should_show_cursorline(args.buf) end,
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function() vim.wo.cursorline = false end,
  },
})

gh.augroup('Utilities', {
  {
    event = 'FileType',
    pattern = { 'gitcommit', 'gitrebase' },
    command = 'set bufhidden=delete',
  },
  {
    event = 'FileType',
    pattern = { 'qf' },
    command = 'wincmd J',
  },
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
