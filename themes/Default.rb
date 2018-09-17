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
    attr_accessor :default_monitor

    def initialize dpi
        @dpi = dpi
        @colors = {
            "COLOR0"         => "#1d1f21",
            "COLOR8"         => "#8e93a5",

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

            "COLOR16"        => "#6b86ad",

            "BACKGROUND"     => "#1d1f21",
            "FOREGROUND"     => "#eeeeee",
        }
        dark_mode_file = Dir.home + '.dark-mode'
        @dark_mode = File.read(dark_mode_file) if File.exists?(dark_mode_file)

        @highlight_color = @colors['COLOR6']
        @urgent_color = @colors['COLOR3']
        @inactive_color = @colors['COLOR8']
    end

    def configuration()

      monospace_font = %x(xfconf-query -c xsettings -p /Gtk/MonospaceFontName | grep -Eo '[^0-9]+').chomp
      monospace_font_size = %x(xfconf-query -c xsettings -p /Gtk/MonospaceFontName | grep -Eo '[0-9]+$').chomp.to_i

      @monospace_font = monospace_font
      @monospace_font_style = "Regular"
      @monospace_font_size = monospace_font_size;


      normal_font = %x(xfconf-query -c xsettings -p /Gtk/FontName | grep -Eo '[^0-9]+').chomp
      normal_font_size = %x(xfconf-query -c xsettings -p /Gtk/FontName | grep -Eo '[0-9]+$').chomp.to_i

      @normal_font = normal_font
      @normal_font_style = ""
      @normal_font_size = normal_font_size;

      @normal_font_alternative = @normal_font
      @normal_font_style_alternative = @normal_font_style
      @normal_font_size_alternative = normal_font_size;

      @weather_font = "Weather Icons"
      @weather_font_style = "Regular"
      @weather_font_size = 12;

      @fonts = {
          "monospace"           => Font.new(@monospace_font, @monospace_font_size, @monospace_font_style),
          "normal"              => Font.new(@normal_font, @normal_font_size, @normal_font_style),
           # Fall back to Roboto for Cyrillic in Polybar
          "normal_alternative"  => Font.new(@normal_font_alternative, @normal_font_size_alternative, @normal_font_style_alternative),
          "weather"  => Font.new(@weather_font, @weather_font_size, @weather_font_style)
      }

      available_themes = %x(for i in $(ls /usr/share/themes/); do echo ${i%%/}; done)
      available_themes = available_themes.split("\n")

      available_icons = %x(for i in $(ls /usr/share/icons/); do echo ${i%%/}; done)
      available_icons = available_icons.split("\n")

      @gtk = {
          "theme"                   => %x(xfconf-query -c xsettings -p /Net/ThemeName).chomp,
          "icon_theme"              => %x(xfconf-query -c xsettings -p /Net/IconThemeName).chomp,
          "fallback_icon_theme"     => 'Adwaita',
          "cursor_theme"            => %x(xfconf-query -c xsettings -p /Gtk/CursorThemeName).chomp
      }

      available = available_themes.select {|e| e == @gtk['theme']}
      if available.length == 0
        puts "Chosen theme " + @gtk['theme'] + " not found"
        @gtk['theme'] = 'Adwaita'
      end

      available = available_icons.select {|e| e == @gtk['icon_theme']}
      if available.length == 0
        puts "Chosen icon theme " + @gtk['icon_theme'] + " not found"
        available = available_icons.select {|e| e == 'Numix'}
        if available.length == 1
          @gtk['icon_theme'] = 'Numix'
        else
          @gtk['icon_theme'] = 'Adwaita'
        end
      end

      available = available_icons.select {|e| e == @gtk['cursor_theme']}
      if available.length == 0
        available = available_icons.select {|e| e == 'dmz'}
        if available.length == 1
          @gtk['cursor_theme'] = 'dmz'
        end
        available = available_icons.select {|e| e == 'DMZ-White'}
        if available.length == 1
          @gtk['cursor_theme'] = 'DMZ-White'
        end
      end

      puts @gtk.to_s

      @dunst = {
          "global"          => {
              "font"            => @fonts['normal'].to_dunst,
              "format"          => "<b>%s</b>\\n%b",
              "separator_color" => @colors['COLOR1'],
              "geometry"        => "360x6-6+32",
              "separator_height"=> 2,
              "padding"         => 10,
              "horizontal_padding" => 10,
          },
          "frame"     => {
              "color" => @colors['COLOR2'],
              "width" => 1
          },
          "urgency_low"     => {
              "background"  => @colors['BACKGROUND'],
              "foreground"  => @colors['FOREGROUND'],
              "timeout"     => 5,
              "frame_color" => @colors['COLOR4']
          },
          "urgency_normal"     => {
              "background"  => @colors['BACKGROUND'],
              "foreground"  => @colors['FOREGROUND'],
              "timeout"     => 40,
              "frame_color" => @colors['COLOR2']
          },
          "urgency_critical"     => {
              "background"  => @colors['BACKGROUND'],
              "foreground"  => @colors['FOREGROUND'],
              "timeout"     => 60,
              "frame_color" => @colors['COLOR1']
          },
      }

      %x(i3 --version | grep gaps)
      i3gaps_enabled = $?.exitstatus === 0
      puts "i3 gaps: " + i3gaps_enabled.to_s
      @i3 = {
          "font" => @fonts["normal"].to_i3(@normal_font_size + 3),
          "border" => 4,
          "client" => {
              "focused"           => I3Colors.new(@colors['COLOR0'], @colors['COLOR2'], @colors['BACKGROUND'], @colors['COLOR5']),
              "unfocused"         => I3Colors.new(@colors['BACKGROUND'], @colors['COLOR0'], @colors['FOREGROUND'], @colors['BACKGROUND']),
              "focused_inactive"  => I3Colors.new(@colors['BACKGROUND'], @colors['COLOR0'], @colors['FOREGROUND'], @colors['BACKGROUND']),
              "urgent"            => I3Colors.new(@urgent_color, @urgent_color, @colors['BACKGROUND'], @colors['COLOR5']),
          },
          "gaps" => {
              "inner" => 2,
              "outer" => 0,
              "enabled" => i3gaps_enabled
          },
      }


      @polybar = {
          "background"           => @colors['BACKGROUND'],
          "foreground"           => @colors['FOREGROUND'],
          "highlight_color"      => @colors['COLOR2'],
          "urgent_color"         => @urgent_color,
          "inactive_color"       => @inactive_color,
          "height"               => ((@normal_font_size * 2) * 1.2).to_s + "px",
          "padding"              => 2,
          "tray_padding"         => 2,
          "wm_padding"           => 2,
          "fonts"                => [
              @fonts["normal"].to_polybar(@normal_font_size , 2),
              @fonts["normal_alternative"].to_polybar(@normal_font_size , 2),
              @fonts["monospace"].to_polybar(14, 3),
              @fonts["weather"].to_polybar(9, 2)
          ]
      }

      @byobu = {
          "color.tmux" => {
              "dark" => @colors['BACKGROUND'],
              "light" => @colors['FOREGROUND'],
              "accent" => @urgent_color,
              "highlight" => @highlight_color,
          }
      }

      @ethinterface = %x(route | grep '^default' | grep -o '[^ ]*$').strip!
      @default_monitor = %x(xrandr | grep "connected primary" | grep -Eo -m 1 '[a-zA-Z0-9\-]+' | head -1)
    end

    def configuration_override()

    end

    def get_binding
        binding()
    end
end
