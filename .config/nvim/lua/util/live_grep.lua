local action_state = require('telescope.actions.state')
local transform_mod = require('telescope.actions.mt').transform_mod
local actions = require('telescope.actions')

local M = {}

local live_grep_filters = {
  ---@type nil|string
  iglob_filter = nil,
}

local function run_live_grep(current_input)
  require('telescope.builtin').live_grep({
    additional_args = live_grep_filters.iglob_filter ~= ''
      and function() return { '--iglob', live_grep_filters.iglob_filter } end,
    default_text = current_input,
    prompt_title = live_grep_filters.iglob_filter ~= ''
        and 'Live Grep (--iglob ' .. live_grep_filters.iglob_filter .. ')'
      or 'Live Grep',
  })
end

M.actions = transform_mod({
  set_iglob = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local current_input = action_state.get_current_line()

    vim.ui.input({ prompt = '--iglob', default = live_grep_filters.iglob_filter }, function(input)
      if input == nil then return end

      live_grep_filters.iglob_filter = input

      actions._close(prompt_bufnr, current_picker.initial_mode == 'insert')
      run_live_grep(current_input)
    end)
  end,
})

M.live_grep = function()
  live_grep_filters.iglob_filter = nil

  require('telescope.builtin').live_grep()
end

return M
