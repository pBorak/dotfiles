local fn = vim.fn
local api = vim.api
local contains = vim.tbl_contains

vim.api.nvim_exec(
  [[
   augroup vimrc -- Ensure all autocommands are cleared
   autocmd!
   augroup END
  ]],
  ''
)

local smart_close_filetypes = {
  'help',
  'git-status',
  'git-log',
  'gitcommit',
  'fugitive',
  'fugitiveblame',
  'qf',
}

local function smart_close()
  if fn.winnr '$' ~= 1 then
    api.nvim_win_close(0, true)
  end
end

gh.augroup('SmartClose', {
  {
    -- Auto open grep quickfix window
    event = 'QuickFixCmdPost',
    pattern = { '*grep*' },
    command = 'cwindow',
  },
  {
    -- Close certain filetypes by pressing q.
    event = 'FileType',
    pattern = '*',
    command = function()
      local is_readonly = (vim.bo.readonly or not vim.bo.modifiable) and fn.hasmapto('q', 'n') == 0

      local is_eligible = vim.bo.buftype ~= ''
        or is_readonly
        or vim.wo.previewwindow
        or contains(smart_close_filetypes, vim.bo.filetype)

      if is_eligible then
        gh.nnoremap('q', smart_close, { buffer = 0, nowait = true })
      end
    end,
  },
  {
    -- Close quick fix window if the file containing it was closed
    event = 'BufEnter',
    pattern = '*',
    command = function()
      if fn.winnr '$' == 1 and vim.bo.buftype == 'quickfix' then
        api.nvim_buf_delete(0, { force = true })
      end
    end,
  },
  {
    -- automatically close corresponding loclist when quitting a window
    event = 'QuitPre',
    pattern = '*',
    nested = true,
    command = function()
      if vim.bo.filetype ~= 'qf' then
        vim.cmd 'silent! lclose'
      end
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
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if fn.mode() == 'n' then
        vim.cmd [[echon '']]
      end
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
      vim.highlight.on_yank {
        timeout = 500,
        on_visual = false,
        higroup = 'Visual',
      }
    end,
  },
})

local column_exclude = { 'gitcommit' }
local column_clear = {
  'vimwiki',
  'help',
  'fugitive',
  'org',
  'orgagenda',
}

--- Set or unset the color column depending on the filetype of the buffer and its eligibility
---@param leaving boolean indicates if the function was called on window leave
local function check_color_column(leaving)
  if contains(column_exclude, vim.bo.filetype) then
    return
  end

  local not_eligible = not vim.bo.modifiable or vim.wo.previewwindow or vim.bo.buftype ~= ''

  local small_window = api.nvim_win_get_width(0) <= vim.bo.textwidth + 1
  local is_last_win = #api.nvim_list_wins() == 1

  if
    contains(column_clear, vim.bo.filetype)
    or not_eligible
    or (leaving and not is_last_win)
    or small_window
  then
    vim.wo.colorcolumn = ''
    return
  end
  if vim.wo.colorcolumn == '' then
    vim.wo.colorcolumn = '+1'
  end
end

gh.augroup('CustomColorColumn', {
  {
    -- Update the cursor column to match current window size
    event = { 'WinEnter', 'BufEnter', 'VimResized', 'FileType' },
    pattern = '*',
    command = function()
      check_color_column()
    end,
  },
  {
    event = 'WinLeave',
    pattern = '*',
    command = function()
      check_color_column(true)
    end,
  },
})

gh.augroup('QuickfixBehaviours', {
  -- Automatically jump into the quickfix window on open
  {
    event = { 'QuickFixCmdPost' },
    pattern = { '[^l]*' },
    nested = true,
    command = 'cwindow',
  },
  {
    event = { 'QuickFixCmdPost' },
    pattern = { 'l*' },
    nested = true,
    command = 'lwindow',
  },
})

local function should_show_cursorline()
  return vim.bo.buftype ~= 'terminal'
    and not vim.wo.previewwindow
    and vim.wo.winhighlight == ''
    and vim.bo.filetype ~= ''
end

gh.augroup('Cursorline', {
  {
    event = { 'BufEnter' },
    pattern = { '*' },
    command = function()
      if should_show_cursorline() then
        vim.wo.cursorline = true
      end
    end,
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      vim.wo.cursorline = false
    end,
  },
})

gh.augroup('Utilities', {
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid.
    event = { 'BufWinEnter' },
    pattern = { '*' },
    command = function()
      if vim.bo.ft ~= 'gitcommit' and vim.fn.win_gettype() ~= 'popup' then
        local row, col = unpack(api.nvim_buf_get_mark(0, '"'))
        if { row, col } ~= { 0, 0 } then
          local ok, msg = pcall(api.nvim_win_set_cursor, 0, { row, 0 })
          if not ok then
            vim.notify(msg, 'error', { title = 'Last cursor position' })
          end
        end
      end
    end,
  },
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
  {
    event = 'Syntax',
    pattern = '*',
    command = "if 5000 < line('$') | syntax sync minlines=200 | endif",
  },
})

gh.augroup('TerminalAutocommands', {
  {
    event = 'TermClose',
    pattern = '*',
    command = function()
      --- automatically close a terminal if the job was successful
      if not vim.v.event.status == 0 then
        vim.cmd('bdelete! ' .. fn.expand '<abuf>')
      end
    end,
  },
})
