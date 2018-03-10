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
    attr_accessor :byobu
    attr_accessor :ethinterface

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

            "COLOR6"         => "#1045ed",
            "COLOR14"        => "#1045ed",

            "COLOR7"         => "#ffffff",
            "COLOR15"        => "#ffffff",

            "COLOR16"        => "#555555",

            "BACKGROUND"     => "#1d1f21",
            "FOREGROUND"     => "#eeeeee",
        }
        dark_mode_file = Dir.home + '.dark-mode'
        @dark_mode = File.read(dark_mode_file) if File.exists?(dark_mode_file)

        @highlight_color = @colors['COLOR6']
        @urgent_color = @colors['COLOR3']
        @inactive_color = @colors['COLOR16']
    end

    def configuration()

      # @monospace_font = "FuraMono Nerd Font Mono"
      #@monospace_font = "RobotoMono Nerd Font"
      #@monospace_font = "ProFontIIx Nerd Font Mono"
      #@monospace_font = "mononoki Nerd Font"
      @monospace_font = "Hack Nerd Font Mono"
      #@monospace_font = "SpaceMono Nerd Font Mono"
      @monospace_font_style = "Regular"
      @monospace_font_size = 10;

      @normal_font = "Roboto"
      @normal_font_style = "Regular"
      @normal_font_size = 10;

      @normal_font_alternative = "Roboto"
      @normal_font_style_alternative = "Regular"
      @normal_font_size_alternative = 10;

      @fonts = {
          "monospace"           => Font.new(@monospace_font, @monospace_font_size, @monospace_font_style),
          "normal"              => Font.new(@normal_font, @normal_font_size, @normal_font_style),
           # Fall back to Roboto for Cyrillic in Polybar
          "normal_alternative"  => Font.new(@normal_font_alternative, @normal_font_size_alternative, @normal_font_style_alternative)
      }

      available_themes = %x(for i in $(ls /usr/share/themes/); do echo ${i%%/}; done)
      available_themes = available_themes.split("\n")

      available_icons = %x(for i in $(ls /usr/share/icons/); do echo ${i%%/}; done)
      available_icons = available_icons.split("\n")
      @gtk = {
          "theme"           => "Arc-Darker",
          "icon_theme"      => "Papirus",
      }

      available = available_themes.select {|e| e == @gtk['theme']}
      if available.length == 0
        @gtk['theme'] = 'Adwaita'
      end

      available = available_icons.select {|e| e == @gtk['icon_theme']}
      if available.length == 0
        @gtk['icon_theme'] = 'Adwaita'
      end

      @dunst = {
          "global"          => {
              "font"            => @fonts['normal'].to_dunst,
              "format"          => "<b><i>%s</i></b>\\n%b",
              "separator_color" => @colors['COLOR1'],
              "geometry"        => "360x6-6+32",
              "separator_height"=> 2,
              "padding"         => 10,
              "horizontal_padding" => 10,
          },
          "frame"     => {
              "color" => @colors['COLOR6'],
              "width" => 1
          },
          "urgency_low"     => {
              "background"  => @colors['BACKGROUND'],
              "foreground"  => @colors['FOREGROUND'],
              "timeout"     => 5
          },
          "urgency_normal"     => {
              "background"  => @colors['BACKGROUND'],
              "foreground"  => @colors['FOREGROUND'],
              "timeout"     => 40
          },
          "urgency_critical"     => {
              "background"  => @colors['COLOR0'],
              "foreground"  => @urgent_color,
              "timeout"     => 60
          },
      }

      @i3 = {
          "font" => @fonts["normal"].to_gtk,
          "border" => 2,
          "client" => {
              "focused"           => I3Colors.new(@colors['COLOR16'], @colors['COLOR16'], @colors['FOREGROUND'], @colors['COLOR4']),
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
          "highlight_color"      => @highlight_color,
          "urgent_color"         => @urgent_color,
          "inactive_color"       => @inactive_color,
          "height"               => "28px",
          "padding"              => 1,
          "wm_padding"           => 3,
          "fonts"                => [
              @fonts["normal"].to_polybar(12, -2),
              @fonts["normal_alternative"].to_polybar(12, -2),
              @fonts["monospace"].to_polybar(17, 0)
          ]
      }

      @byobu = {
          "color.tmux" => {
              "dark" => @colors['BACKGROUND'],
              "light" => @colors['FOREGROUND'],
              "accent" => @urgent_color,
              "hightlight" => @highlight_color,
          }
      }

      @ethinterface = %x(route | grep '^default' | grep -o '[^ ]*$').strip!
    end

    def configuration_override()

    end

    def get_binding
        binding()
    end
end
