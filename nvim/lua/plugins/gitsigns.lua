return function()
  local gitsigns = require 'gitsigns'

  gitsigns.setup {
    signs = {
      add = { hl = 'GitSignsAdd', text = '▌' },
      change = { hl = 'GitSignsChange', text = '▌' },
      delete = { hl = 'GitSignsDelete', text = '▌' },
      topdelete = { hl = 'GitSignsDelete', text = '▌' },
      changedelete = { hl = 'GitSignsChange', text = '▌' },
    },
    keymaps = {
      -- Default keymap options
      noremap = true,
      buffer = true,
      ['n ]g'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
      ['n [g'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
      ['n <leader>gw'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
      ['n <leader>gr'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
      ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
      ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
      ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
      ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
      ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
      ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
      ['n <leader>hl'] = '<cmd>lua require"gitsigns".setqflist("all")<CR>',
    },
  }
end
