local M = {}

function M.on_lsp_attach(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.is_vim_list_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local location_list = vim.fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == 'qf' or is_loc_list then return true end
  end
  return false
end

function M.toggle_list(list_type)
  local is_location_target = list_type == 'location'
  local cmd = is_location_target and { 'lclose', 'lopen' } or { 'cclose', 'copen' }
  local is_open = M.is_vim_list_open()
  if is_open then return vim.cmd[cmd[1]]() end
  local list = is_location_target and vim.fn.getloclist(0) or vim.fn.getqflist()
  if vim.tbl_isempty(list) then
    local msg_prefix = (is_location_target and 'Location' or 'QuickFix')
    return vim.notify(msg_prefix .. ' List is Empty.', vim.log.levels.WARN)
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
