IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:COMMAND_ALIASES].merge!(
  ex: :exit,
  l: :whereami,
  src: :show_source,
  ex!: :exit!,
  c: :continue
)

begin
  require "#{Dir.home}/.config/ruby/reline_fzf_patch"
  require "#{Dir.home}/.config/ruby/clipboard_io"
rescue LoadError => e
  puts "Error Loading irbrc (#{e})"
end
