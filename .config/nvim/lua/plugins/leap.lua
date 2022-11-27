return function()
  require('leap').add_default_mappings()
  local function leap_all_windows()
    require('leap').leap({
      target_windows = vim.tbl_filter(
        function(win) return vim.api.nvim_win_get_config(win).focusable end,
        vim.api.nvim_tabpage_list_wins(0)
      ),
    })
  end
  vim.keymap.set({ 'n', 'v' }, 's', leap_all_windows)
end
