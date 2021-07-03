return function()
  require('nvim-gps').setup {
    separator = ' ',
    icons = {
      ['class-name'] = gh.style.lsp.kinds['Class'] .. ' ',
      ['container-name'] = gh.style.lsp.kinds['Field'] .. ' ',
      ['module-name'] = gh.style.lsp.kinds['Module'] .. ' ',
    },
    languages = {
      ['ruby'] = {
        icons = {
          ['container-name'] = gh.style.lsp.kinds['Module'] .. ' ',
        },
      },
    },
  }
end
