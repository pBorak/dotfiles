IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:COMMAND_ALIASES].merge!(
  e: :exit,
  l: :whereami,
  src: :show_source,
  e!: :exit!,
  c: :continue
)

begin
  require "#{Dir.home}/.config/ruby/reline_fzf_patch"
  require "#{Dir.home}/.config/ruby/clipboard_io"
rescue LoadError => e
  puts "Error Loading irbrc (#{e})"
end
