return function()
  require('dressing').setup {
    select = {
      telescope = require('telescope.themes').get_cursor {
        layout_config = {
          height = function(self, _, max_lines)
            local results = #self.finder.results
            local PADDING = 4 -- this represents the size of the telescope window
            local LIMIT = math.floor(max_lines / 2)
            return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
          end,
        },
      },
    },
  }
end
