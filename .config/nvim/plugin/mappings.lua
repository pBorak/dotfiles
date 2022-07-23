local fn = vim.fn
local noisy = { silent = false }

local nnoremap = gh.nnoremap
local xnoremap = gh.xnoremap
local vnoremap = gh.vnoremap
local onoremap = gh.onoremap
local cnoremap = gh.cnoremap
local tnoremap = gh.tnoremap

--------------------------------------------------------------------------------
-- Terminal
--------------------------------------------------------------------------------
gh.augroup('AddTerminalMappings', {
  {
    event = 'TermOpen',
    pattern = { 'term://*' },
    command = function()
      if vim.bo.filetype == '' or vim.bo.filetype == 'toggleterm' then
        local opts = { silent = false, buffer = 0 }
        tnoremap('<esc>', [[<C-\><C-n>]], opts)
        tnoremap('<C-h>', [[<C-\><C-n><C-W>h]], opts)
        tnoremap('<C-j>', [[<C-\><C-n><C-W>j]], opts)
        tnoremap('<C-k>', [[<C-\><C-n><C-W>k]], opts)
        tnoremap('<C-l>', [[<C-\><C-n><C-W>l]], opts)
      end
    end,
  },
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

xnoremap('@', ':<C-u>call ExecuteMacroOverVisualRange()<CR>', noisy)
-- Map Q to replay q register
nnoremap('Q', '@q')
--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------
-- Switch between the last two files
nnoremap('<leader><leader>', [[<c-^>]])
--------------------------------------------------------------------------------
-- Miscellaneous
--------------------------------------------------------------------------------
-- Capitalize word under the cursor
nnoremap('<leader>U', 'gUiw`]')

nnoremap(';', ':', noisy)
-- Esc should clear hlsearch if there is one
nnoremap('<ESC>', [[ v:hlsearch ? "\<ESC>:nohl\<CR>" : "\<ESC>" ]], { expr = true })
--------------------------------------------------------------------------------
-- Moving lines/visual block
--------------------------------------------------------------------------------
xnoremap(']e', ":move'>+<CR>='[gv")
xnoremap('[e', ":move-2<CR>='[gv")
nnoremap(']e', '<cmd>move+<CR>==')
nnoremap('[e', '<cmd>move-2<CR>==')
--------------------------------------------------------------------------------
-- Add Empty space above and below
--------------------------------------------------------------------------------
nnoremap('[<space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
nnoremap(']<space>', [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
--------------------------------------------------------------------------------
-- Quickfix Navigation
--------------------------------------------------------------------------------
nnoremap(']q', '<cmd>cnext<CR>zz')
nnoremap('[q', '<cmd>cprev<CR>zz')
nnoremap(']l', '<cmd>lnext<cr>zz')
nnoremap('[l', '<cmd>lprev<cr>zz')
--------------------------------------------------------------------------------
-- Tab navigation
--------------------------------------------------------------------------------
nnoremap(']t', '<cmd>tprevious<CR>')
nnoremap('[t', '<cmd>tnext<CR>')
--------------------------------------------------------------------------------
-- Windows
--------------------------------------------------------------------------------
-- make . work with visually selected lines
vnoremap('.', ':norm.<CR>')
-- edit file in current directory
nnoremap('<leader>e', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], noisy)
--------------------------------------------------------------------------------
-- Quick find/replace
--------------------------------------------------------------------------------
-- Replace all occurrences under the cursor in buffer
nnoremap('\\s', [[<cmd>let @s='\<'.expand('<cword>').'\>'<CR>:%s/<C-r>s//<Left>]], noisy)
xnoremap('\\s', [["sy:%s/<C-r>s//<Left>]], noisy)
-- Replace occurrence under the cursor, then use dot to change next occurrences
nnoremap('cn', '*``cgn')
nnoremap('cN', '*``cgN')
vim.g.mc = vim.api.nvim_replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]], true, true, true)
xnoremap('cn', [[g:mc . "``cgn"]], { expr = true, silent = true })
xnoremap('cN', [[g:mc . "``cgN"]], { expr = true, silent = true })
--------------------------------------------------------------------------------
-- Commandline mappings
--------------------------------------------------------------------------------
cnoremap('<C-a>', '<Home>')
cnoremap('<C-e>', '<End>')
cnoremap('<C-b>', '<Left>')
cnoremap('<C-f>', '<Right>')
-------------------------------------------------------------------------------
-- ?ie | entire object
-------------------------------------------------------------------------------
xnoremap('ie', [[gg0oG$]])
onoremap('ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])
--------------------------------------------------------------------------------
-- Core navigation
--------------------------------------------------------------------------------
-- Store relative line number jumps in the jumplist.
nnoremap('j', [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
nnoremap('k', [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
nnoremap('0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
-- when going to the end of the line in visual mode ignore whitespace characters
vnoremap('$', 'g_')
--------------------------------------------------------------------------------
-- Toggle list
--------------------------------------------------------------------------------
--- Utility function to toggle the location or the quickfix list
---@param list_type '"quickfix"' | '"location"'
---@return nil
function gh.toggle_list(list_type)
  local is_location_target = list_type == 'location'
  local prefix = is_location_target and 'l' or 'c'
  local L = vim.log.levels
  local is_open = gh.is_vim_list_open()
  if is_open then return fn.execute(prefix .. 'close') end
  local list = is_location_target and fn.getloclist(0) or fn.getqflist()
  if vim.tbl_isempty(list) then
    local msg_prefix = (is_location_target and 'Location' or 'QuickFix')
    return vim.notify(msg_prefix .. ' List is Empty.', L.WARN)
  end

  local winnr = fn.winnr()
  fn.execute(prefix .. 'open')
  if fn.winnr() ~= winnr then vim.cmd.wincmd('p') end
end

nnoremap('<leader>cc', function() gh.toggle_list('quickfix') end)
