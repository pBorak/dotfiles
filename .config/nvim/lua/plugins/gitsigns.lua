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
    on_attach = function()
      gh.nnoremap(
        ']g',
        "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
        { expr = true }
      )
      gh.nnoremap(
        '[g',
        "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
        { expr = true }
      )
      gh.nnoremap('<leader>gw', '<cmd>lua require"gitsigns".stage_buffer()<CR>')
      gh.nnoremap('<leader>gr', '<cmd>lua require"gitsigns".reset_buffer()<CR>')
      gh.nnoremap('<leader>hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>')
      gh.vnoremap(
        '<leader>hs',
        '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>'
      )
      gh.nnoremap('<leader>hu', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>')
      gh.nnoremap('<leader>hr', '<cmd>lua require"gitsigns".reset_hunk()<CR>')
      gh.vnoremap(
        '<leader>hr',
        '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>'
      )
      gh.nnoremap('<leader>hp', '<cmd>lua require"gitsigns".preview_hunk()<CR>')
      gh.nnoremap('<leader>hl', '<cmd>lua require"gitsigns".setqflist("all")<CR>')
    end,
  }
end
