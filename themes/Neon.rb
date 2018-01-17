class Neon < Default

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
    end

end