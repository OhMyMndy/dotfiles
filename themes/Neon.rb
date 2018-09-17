require_relative 'Default'

class Neon < Default

    def initialize dpi
        @dpi = dpi
        @colors = {
            # Black
            "COLOR0"         => "#1a1b21",
            "COLOR8"         => "#959498",

            # Red
            "COLOR1"         => "#ff1835",
            "COLOR9"         => "#ff1835",

            # Green
            "COLOR2"         => "#31ff7f",
            "COLOR10"        => "#31ff7f",

            # Yellow
            "COLOR3"         => "#f3ff4d",
            "COLOR11"        => "#f3ff4d",

            # Blue
            "COLOR4"         => "#39c2ed",
            "COLOR12"        => "#39c2ed",

            # Purple / Magenta
            "COLOR5"         => "#ff68d1",
            "COLOR13"        => "#ff68d1",

            # Cyan
            "COLOR6"         => "#169375",
            "COLOR14"        => "#169375",

            # White
            "COLOR7"         => "#dbdbdb",
            "COLOR15"        => "#ffffff",

            "COLOR16"        => "#3d96b7",

            "BACKGROUND"     => "#101010",
            "FOREGROUND"     => "#ffffff",
        }

        dark_mode_file = Dir.home + '.dark-mode'
        @dark_mode = File.read(dark_mode_file) if File.exist?(dark_mode_file)

        @highlight_color = @colors['COLOR5']
        @urgent_color = @colors['COLOR4']
        @inactive_color = @colors['COLOR8']
    end

end
