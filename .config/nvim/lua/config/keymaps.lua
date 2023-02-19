local Util = require('util')
--------------------------------------------------------------------------------
-- Terminal
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'neotest-attach' },
  callback = function() vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { silent = false, buffer = 0 }) end,
})
--------------------------------------------------------------------------------
-- MACROS
--------------------------------------------------------------------------------
-- repeat macros across a visual range
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])
vim.keymap.set('x', '@', ':<C-u>call ExecuteMacroOverVisualRange()<CR>', { silent = false })
--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------
-- Switch between the last two files
vim.keymap.set('n', '<leader><leader>', [[<c-^>]])
--------------------------------------------------------------------------------
-- Miscellaneous
--------------------------------------------------------------------------------
-- Capitalize word under the cursor
vim.keymap.set('n', '<leader>U', 'gUiw`]')

vim.keymap.set({ 'n', 'x' }, ';', ':')
-- Esc should clear hlsearch if there is one
vim.keymap.set('n', '<ESC>', [[ v:hlsearch ? "\<ESC>:nohl\<CR>" : "\<ESC>" ]], { expr = true })
--------------------------------------------------------------------------------
-- Moving lines/visual block
--------------------------------------------------------------------------------
vim.keymap.set('x', ']e', ":move'>+<CR>='[gv")
vim.keymap.set('x', '[e', ":move-2<CR>='[gv")
vim.keymap.set('n', ']e', '<cmd>move+<CR>==')
vim.keymap.set('n', '[e', '<cmd>move-2<CR>==')
--------------------------------------------------------------------------------
-- Add Empty space above and below
--------------------------------------------------------------------------------
vim.keymap.set('n', '[<space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
vim.keymap.set('n', ']<space>', [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
--------------------------------------------------------------------------------
-- Quickfix Navigation
--------------------------------------------------------------------------------
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz')
vim.keymap.set('n', ']l', '<cmd>lnext<cr>zz')
vim.keymap.set('n', '[l', '<cmd>lprev<cr>zz')
--------------------------------------------------------------------------------
-- Tab navigation
--------------------------------------------------------------------------------
vim.keymap.set('n', ']t', '<cmd>tprevious<CR>')
vim.keymap.set('n', '[t', '<cmd>tnext<CR>')
--------------------------------------------------------------------------------
-- Windows
--------------------------------------------------------------------------------
-- make . work with visually selected lines
vim.keymap.set('v', '.', ':norm.<CR>')
--------------------------------------------------------------------------------
-- Quick find/replace
--------------------------------------------------------------------------------
-- Replace all occurrences under the cursor in buffer
vim.keymap.set(
  'n',
  '\\s',
  [[<cmd>let @s='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>s//<Left>]],
  { silent = false }
)
vim.keymap.set('x', '\\s', [["sy:%s/<C-r>s//<Left>]], { silent = false })
--------------------------------------------------------------------------------
-- Commandline mappings
--------------------------------------------------------------------------------
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-f>', '<Right>')
-------------------------------------------------------------------------------
-- ?ie | entire object
-------------------------------------------------------------------------------
vim.keymap.set('x', 'ie', [[gg0oG$]])
vim.keymap.set('o', 'ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])
--------------------------------------------------------------------------------
-- Core navigation
--------------------------------------------------------------------------------
-- Store relative line number jumps in the jumplist.
vim.keymap.set(
  'n',
  'j',
  [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']],
  { expr = true, silent = true }
)
vim.keymap.set(
  'n',
  'k',
  [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']],
  { expr = true, silent = true }
)
-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
vim.keymap.set(
  'n',
  '0',
  "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'",
  { expr = true }
)

vim.keymap.set('n', '<leader>cc', function() Util.toggle_list('quickfix') end)
