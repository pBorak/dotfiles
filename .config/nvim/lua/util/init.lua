local M = {}

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

local function find_project_root()
  local markers = { 'Gemfile', '.git' }
  local current_dir = vim.fn.expand('%:p:h')

  while current_dir ~= '/' do
    for _, marker in ipairs(markers) do
      local marker_path = current_dir .. '/' .. marker
      if vim.fn.isdirectory(marker_path) == 1 or vim.fn.filereadable(marker_path) == 1 then
        return current_dir
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  -- If no project root found, use the directory of the current file
  return vim.fn.expand('%:p:h')
end

-- Function to open the current file in Cursor at the current line
function M.open_in_cursor()
  local file_path = vim.fn.expand('%:p')
  local line_number = vim.fn.line('.')
  local workspace_dir = find_project_root()

  local cmd = string.format('cursor "%s" --goto "%s:%s"', workspace_dir, file_path, line_number)

  vim.notify('Opening in Cursor: ' .. workspace_dir, vim.log.levels.INFO)

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify('Successfully opened in Cursor', vim.log.levels.INFO)
      else
        vim.notify(
          'Failed to open in Cursor (exit code: ' .. exit_code .. ')',
          vim.log.levels.ERROR
        )
      end
    end,
    detach = true,
  })
end

return M
