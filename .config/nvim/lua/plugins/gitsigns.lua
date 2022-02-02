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
      local gs = package.loaded.gitsigns

      gh.nnoremap(']g', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
      gh.nnoremap('[g', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
      gh.nnoremap('<leader>gw', gs.stage_buffer)
      gh.nnoremap('<leader>gr', gs.reset_buffer)
      gh.nnoremap('<leader>hs', ':Gitsigns stage_hunk<CR>')
      gh.vnoremap('<leader>hs', ':Gitsigns stage_hunk<CR>')
      gh.nnoremap('<leader>hu', gs.undo_stage_hunk)
      gh.nnoremap('<leader>hr', ':Gitsigns reset_hunk<CR>')
      gh.vnoremap('<leader>hr', ':Gitsigns reset_hunk<CR>')
      gh.nnoremap('<leader>hp', gs.preview_hunk)
      gh.nnoremap('<leader>hl', function()
        gs.setqflist 'all'
      end)
    end,
  }
end
