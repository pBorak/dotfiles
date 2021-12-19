local abbreviations = {
  Wq = 'wq',
  WQ = 'wq',
  Wqa = 'wqa',
  WQA = 'wqa',
  W = 'w',
  Q = 'q',
  Qa = 'qa',
  QA = 'qa',
}

for left, right in pairs(abbreviations) do
  vim.cmd(string.format('cnoreabbrev %s %s', left, right))
end
