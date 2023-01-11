return function()
  require('neotest').setup({
    discovery = { enabled = true },
    diagnostic = {
      enabled = true,
    },
    adapters = {
      require('neotest-rspec')({
        rspec_cmd = './neotest_docker_script.sh',
      }),
    },
    icons = {
      expanded = '',
      child_prefix = '',
      child_indent = '',
      final_child_prefix = '',
      non_collapsible = '',
      collapsed = '',
      passed = '',
      running = '',
      failed = '',
      unknown = '',
      skipped = '',
    },
    quickfix = {
      enabled = true,
      open = false,
    },
    floating = {
      border = 'single',
      max_height = 0.8,
      max_width = 0.9,
    },
  })

  local function open() require('neotest').output.open({ enter = true, short = false }) end
  local function run_file() require('neotest').run.run(vim.fn.expand('%')) end
  local function nearest() require('neotest').run.run() end
  local function toggle_summary() require('neotest').summary.toggle() end
  local function rerun() require('neotest').run.run_last() end
  local function attach() require('neotest').run.attach() end

  gh.nnoremap('<leader>ts', toggle_summary)
  gh.nnoremap('<leader>to', open)
  gh.nnoremap('<leader>tt', nearest)
  gh.nnoremap('<leader>tf', run_file)
  gh.nnoremap('<leader>tl', rerun)
  gh.nnoremap('<leader>ta', attach)
end
