return function()
  gh.nnoremap('<localleader>m', require('harpoon.mark').add_file)
  gh.nnoremap('<localleader><localleader>', require('harpoon.ui').toggle_quick_menu)

  gh.nnoremap('<localleader>a', [[:lua require("harpoon.ui").nav_file(1)<CR>]])
  gh.nnoremap('<localleader>s', [[:lua require("harpoon.ui").nav_file(2)<CR>]])
  gh.nnoremap('<localleader>d', [[:lua require("harpoon.ui").nav_file(3)<CR>]])
  gh.nnoremap('<localleader>f', [[:lua require("harpoon.ui").nav_file(4)<CR>]])
end
