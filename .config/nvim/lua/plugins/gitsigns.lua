return function()
  local gitsigns = require('gitsigns')

  gitsigns.setup({
    signs = {
      add = { hl = 'GitSignsAdd', text = '▌' },
      change = { hl = 'GitSignsChange', text = '▌' },
      delete = { hl = 'GitSignsDelete', text = '▌' },
      topdelete = { hl = 'GitSignsDelete', text = '▌' },
      changedelete = { hl = 'GitSignsChange', text = '▌' },
    },
    on_attach = function()
      local gs = package.loaded.gitsigns

      gh.nnoremap(']g', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })
      gh.nnoremap('[g', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })
      vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { silent = true })
      gh.nnoremap('<leader>gw', gs.stage_buffer)
      gh.nnoremap('<leader>gr', gs.reset_buffer)
      gh.nnoremap('<leader>hu', gs.undo_stage_hunk)
      gh.nnoremap('<leader>hp', gs.preview_hunk)
      gh.nnoremap('<leader>hl', function() gs.setqflist('all') end)
    end,
  })
end
