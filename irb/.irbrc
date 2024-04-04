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
rescue LoadError => e
  puts "Error Loading irbrc (#{e})"
end
