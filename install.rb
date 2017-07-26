require 'erb'
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

puts "Using theme '#{$theme}'"
require_relative "themes/#{$theme}.rb"
$theme.ucfirst!

$theme_instance = Object.const_get($theme).new

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

root_dir = File.dirname(__FILE__)

Dir.chdir root_dir

Dir.glob ['*.erb', '.config/**/*.erb'], File::FNM_DOTMATCH do |file|
    new_file_name = get_new_filename file
    

    new_content = compile(file)
    puts new_file_name + " length " + new_content.length.to_s
    if new_content.empty? || new_content.length < 2
        puts "Content is empty"
        exit 2
    end
    File.delete new_file_name if File.exists? new_file_name
    File.write new_file_name, new_content
end


%x( xrdb -remove )
%x( xrdb -override ~/.Xresources )

%x( killall dunst > /dev/null || echo "No dunst found"; dunst  > /dev/null 2>&1 & )
%x( notify-send -i /usr/share/icons/gnome/256x256/status/trophy-gold.png "Summary of the message" "Here comes the message" )


#############
# Gnome desktop settings
#############
%x( dconf write /org/gnome/desktop/interface/font-name "'#{$theme_instance.fonts['normal'].to_gtk}'" )
%x( dconf write /org/gnome/desktop/interface/monospace-font-name "'#{$theme_instance.fonts['monospace'].to_gtk}'" )
%x( dconf write /org/gnome/desktop/interface/text-scaling-factor 1 )

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
