require_relative 'Default'

class Neon < Default

    def initialize dpi
        @colors = {
            "COLOR0"         => "#1a1b21",
            "COLOR8"         => "#455160",

            "COLOR1"         => "#cb271c",
            "COLOR9"         => "#cb271c",

            "COLOR2"         => "#17934c",
            "COLOR10"        => "#17934c",

            "COLOR3"         => "#eeec26",
            "COLOR11"        => "#eeec26",

            "COLOR4"         => "#39c2ed",
            "COLOR12"        => "#39c2ed",

            "COLOR5"         => "#a942af",
            "COLOR13"        => "#a942af",

            "COLOR6"         => "#2163c6",
            "COLOR14"        => "#2163c6",

            "COLOR7"         => "#ffffff",
            "COLOR15"        => "#ffffff",

            "COLOR16"        => "#313b49",

            "BACKGROUND"     => "#1a1b21",
            "FOREGROUND"     => "#eeeeee",
        }

        dark_mode_file = Dir.home + '.dark-mode'
        @dark_mode = File.read(dark_mode_file) if File.exist?(dark_mode_file)

        @highlight_color = @colors['COLOR6']
        @urgent_color = @colors['COLOR3']
        @inactive_color = @colors['COLOR16']
    end

    def configuration_override
      @gtk = {
          "theme"           => "Windows-10",
          "icon_theme"      => "Arc-Icons",
      }
    end
end
