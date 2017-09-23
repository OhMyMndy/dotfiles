class Default
    # include ERB::Util
    attr_accessor :colors
    attr_accessor :dark_mode
    attr_accessor :fonts
    attr_accessor :gtk
    attr_accessor :dunst
    attr_accessor :i3
    attr_accessor :polybar
    attr_accessor :dpi

    def initialize dpi
        @dpi = dpi
        @colors = {
            "COLOR0"         => "#1d1f21",
            "COLOR8"         => "#969896",

            "COLOR1"         => "#cc342b",
            "COLOR9"         => "#cc342b",

            "COLOR2"         => "#198844",
            "COLOR10"        => "#198844",

            "COLOR3"         => "#fba922",
            "COLOR11"        => "#fba922",

            "COLOR4"         => "#3971ed",
            "COLOR12"        => "#3971ed",

            "COLOR5"         => "#a36ac7",
            "COLOR13"        => "#a36ac7",

            "COLOR6"         => "#3971ed",
            "COLOR14"        => "#3971ed",

            "COLOR7"         => "#ffffff",
            "COLOR15"        => "#ffffff",

            "COLOR16"        => "#888888",

            "BACKGROUND"     => "#1d1f21",
            "FOREGROUND"     => "#eeeeee",
        }
        dark_mode_file = Dir.home + '.dark-mode'
        @dark_mode = File.read(dark_mode_file) if File.exists?(dark_mode_file)

        @highlight_color = @colors['COLOR2']
        @urgent_color = @colors['COLOR6']


        @monospace_font = "SauceCodePro Nerd Font"
        @monospace_font_style = "Regular"
        @monospace_font_size = 11;
        @normal_font = "SFNS Display"
        @normal_font_style = "Regular"
        @normal_font_size = 10;

        @fonts = {
            "monospace"       => Font.new(@monospace_font, @monospace_font_size, @monospace_font_style),
            "normal"          => Font.new(@normal_font, @normal_font_size, @normal_font_style)
        }

        @gtk = {
            "theme"           => "Paper",
            "icon_theme"      => "Papirus",
        }

        @dunst = {
            "global"          => {
                "font"            => @fonts['normal'].to_dunst,
                "format"          => "<b><i>%s</i></b>\\n%b",
                "separator_color" => @colors['COLOR4'],
                "geometry"        => "360x6-6+32",
                "separator_height"=> 2,
                "padding"         => 12,
                "horizontal_padding" => 12,
            },
            "frame"     => {
                "color" => @colors['COLOR2'],
            },
            "urgency_low"     => {
                "background"  => @colors['BACKGROUND'],
                "foreground"  => @colors['FOREGROUND'],
                "timeout"     => 5
            },
            "urgency_normal"     => {
                "background"  => @colors['BACKGROUND'],
                "foreground"  => @colors['FOREGROUND'],
                "timeout"     => 20
            },
            "urgency_critical"     => {
                "background"  => @colors['COLOR0'],
                "foreground"  => @urgent_color,
                "timeout"     => 30
            },
        }

        @i3 = {
            "font" => @fonts["normal"].to_gtk,
            "border" => 2,
            "client" => {
                "focused"           => I3Colors.new(@colors['COLOR16'], @colors['COLOR16'], @colors['COLOR0'], @colors['COLOR4']),
                "unfocused"         => I3Colors.new(@colors['COLOR0'], @colors['COLOR0'], @colors['FOREGROUND'], @colors['COLOR4']),
                "focused_inactive"  => I3Colors.new(@colors['COLOR0'], @colors['COLOR0'], @colors['FOREGROUND'], @colors['COLOR4']),
                "urgent"            => I3Colors.new(@urgent_color, @urgent_color, @colors['COLOR7'], @colors['COLOR4']),
            },
            "gaps" => {
                "inner" => 2,
                "outer" => 0
            },
        }


        @polybar = {
            "background"           => @colors['BACKGROUND'],
            "foreground"           => @colors['FOREGROUND'],
            "underline_color"      => @highlight_color,
            "height"               => 24,
            "fonts"                => [
                @fonts["normal"].to_polybar,
                @fonts["monospace"].to_polybar
            ]
        }
    end

    def get_binding
        binding()
    end
end