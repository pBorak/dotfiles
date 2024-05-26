local M = {}

function M.is_vim_list_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'qf' then return true end
  end
  return false
end

function M.toggle_quickfix()
  local cmd = { 'cclose', 'copen' }
  local is_open = M.is_vim_list_open()
  if is_open then return vim.cmd[cmd[1]]() end
  local list = vim.fn.getqflist()
  if vim.tbl_isempty(list) then
    return vim.notify('Quickfix list is empty.', vim.log.levels.WARN)
  end

  local winnr = vim.fn.winnr()
  vim.cmd[cmd[2]]()
  if vim.fn.winnr() ~= winnr then vim.cmd.wincmd('p') end
end

function M.empty(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'string' then
    return item == ''
  elseif item_type == 'number' then
    return item <= 0
  elseif item_type == 'table' then
    return vim.tbl_isempty(item)
  end
end

return M
