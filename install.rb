require 'erb'
require 'fileutils'
require_relative 'functions.rb'

class String
  def ucfirst!
    self[0] = self[0,1].upcase
    self
  end
end


$args = Hash[ ARGV.flat_map{|s| s.scan(/--?([^=\s]+)(?:=(\S+))?/) } ]

$theme = 'default'
if $args.key?('theme') && File.exists("themes/" + $args['theme'] + '.erb')
    $theme = $args['theme']
end

$dpi = $args.key?('dpi') && $args['dpi'].to_i > 0 ? $args['dpi'].to_i : 96


puts "Using theme '#{$theme}'"
puts "Dpi         '#{$dpi}'"
require_relative "themes/#{$theme}.rb"
$theme.ucfirst!

$theme_instance = Object.const_get($theme).new $dpi

$parameters = $theme_instance.get_binding
puts "Parameters: "
puts eval("fonts", $parameters)

def compile input_file
    renderer = ERB.new File.read(input_file)
    renderer.result($parameters)
end

def get_new_filename file_name
    Dir.home + '/' + file_name.gsub(/\.erb$/, '')
end

#############
## ERB
## Compile ERB files

#############

$root_dir = File.dirname(__FILE__)

Dir.chdir $root_dir


Dir.glob ['*.erb', '.byobu/*.erb', '.config/**/*.erb'], File::FNM_DOTMATCH do |file|
    new_file_name = get_new_filename file
    

    new_content = compile(file)
    puts new_file_name + " length " + new_content.length.to_s
    if new_content.empty? || new_content.length < 2
        puts "Content is empty"
        exit 2
    end
    dirname = File.dirname(new_file_name)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
    File.open(new_file_name, 'w') { |f| f.write new_content }

end

%x( xrdb -remove )
%x( xrdb -override ~/.Xresources )



Process.fork { system "bash \"#{$root_dir}/link.sh\" > /tmp/output-link.sh 2>&1 " }
Process.fork { system "pkill dunst; dunst > /dev/null 2>&1 " }
%x( notify-send -i /usr/share/icons/gnome/256x256/status/trophy-gold.png "Summary of the message" "Here comes the message" )
Process.fork { system "xrandr --dpi #{$dpi} > /dev/null 2>&1 " }
Process.fork { system "pkill polybar; polybar top >/dev/null 2>&1 " }
# Process.fork { system "sudo hardcode-tray --theme Papirus --apply" }

#############
# Gnome desktop settings
#############
#%x( dconf write /org/gnome/desktop/interface/font-name "'#{$theme_instance.fonts['normal'].to_gtk}'" )
#%x( dconf write /org/gnome/desktop/interface/monospace-font-name "'#{$theme_instance.fonts['monospace'].to_gtk}'" )
#%x( dconf write /org/gnome/desktop/interface/text-scaling-factor 1 )

#############
# Install even better ls
#############
%x( which ls-i )
if $?.exitstatus != 0
    %x( sh -c "$(curl -fsSL https://raw.githubusercontent.com/illinoisjackson/even-better-ls/master/install.sh)" )
end


exit

#############
## Git settings
#############
%x( git config --global pager.log 'diff-highlight | less' )
%x( git config --global pager.show 'diff-highlight | less' )
%x( git config --global pager.diff 'diff-highlight | less' )

%x( git config --global user.name "Mandy Schoep" )
# git config --global user.email


#############
## Copy all other files
#############


files = [
    ".vimrc"
]

files.each do |file|
    file_location = Dir.home + "/" + file

    puts file_location
end
