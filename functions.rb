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
            "#{@name} #{@style}"
        else
            "#{@name}"
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