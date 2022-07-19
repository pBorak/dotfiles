return function()
  require('leap').set_default_keymaps()
  local function leap_all_windows()
    local focusable_windows_on_tabpage = vim.tbl_filter(function(win)
      return vim.api.nvim_win_get_config(win).focusable
    end, vim.api.nvim_tabpage_list_wins(0))
    require('leap').leap { target_windows = focusable_windows_on_tabpage }
  end
  vim.keymap.set({ 'n', 'v' }, 's', leap_all_windows)
  vim.keymap.set({ 'n', 'v' }, 'S', leap_all_windows)
end
