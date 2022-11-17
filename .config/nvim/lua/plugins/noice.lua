return function()
  require('noice').setup({
    routes = {
      {
        filter = { event = 'msg_show', kind = '', find = 'written' },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'notify',
          find = 'Format request failed, no matching language servers.',
        },
        opts = { skip = true },
      },
    },
    lsp = {
      signature = {
        enabled = false,
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
      inc_rename = false,
    },
  })
end
