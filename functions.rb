require 'json'

class Font
    attr_accessor :name
    attr_accessor :size
    attr_accessor :type

    def initialize name, size, style
        @name = name
        @size = size
        @style = style
    end

    def to_rofi
        "#{@name} #{@style} #{@size}"
    end

    def to_xterm
        if @style
            "#{@name}:style=#{@style}".gsub! ' ', '\\ '
        else
            "#{@name}".gsub! ' ', '\\ '
        end
    end

    def to_i3
        to_xterm
    end

    def to_gtk
        "#{@name} #{@size}"
    end

    def to_dunst
        to_gtk
    end

    def to_xft
        "xft:#{@name}:pixelsize=#{@size}:antialias=true:hinting=true".gsub! ' ', '\\ '
    end

    def to_xft_bold
        if @style
            "xft:#{@name}:bold:pixelsize=#{@size}:antialias=true:hinting=true:style=#{@style}".gsub! ' ', '\\ '
        else
            "xft:#{@name}:bold:pixelsize=#{@size}:antialias=true:hinting=true".gsub! ' ', '\\ '
        end
    end

    def to_polybar (size=nil, offset=nil)
        size = @size if size == nil
        size = size * 1.15
        offset = 0 if offset == nil
        # DejaVuSansMono Nerd Font:style=Book:pixelsize=11;0
        if @style
            "#{@name}:style=#{@style}:pixelsize=#{size};#{offset}"
        else
            "#{@name}:pixelsize=#{size};#{offset}"
        end
    end

end


class I3Colors

    def initialize border_color, background_color, text_color, indicator_color
        @border_color = border_color
        @background_color = background_color
        @text_color = text_color
        @indicator_color = indicator_color
    end

    def to_s
        "#{@border_color}      #{@background_color}      #{@text_color}      #{@indicator_color}"
    end

end

class SlackColors
end

def set_slack_theme
    file_name = Dir.home + '/.config/Slack/storage/slack-teams'
    puts file_name
    colors = '{"column_bg":"#073642","menu_bg":"#002B36","active_item":"#B58900","active_item_text":"#FDF6E3","hover_item":"#CB4B16","text_color":"#FDF6E3","active_presence":"#2AA198","badge":"#DC322F"}'

    File.open(file_name, 'r+') { |f| 
        json = f.read
        puts json
        json = JSON.parse(json) if json && json.length >= 2
        if json
            json.each do |k, el|
                puts k
                # el['theme'] = el['theme'] +
            end
        end
    }
    
end

set_slack_theme