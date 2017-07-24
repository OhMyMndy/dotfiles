#!/usr/bin/env bash

cat <<EOF
#include ".Xresources-local"
EOF


dark_mode=$(cat ~/.dark-mode 2>/dev/null || echo '1')

if [ "$dark_mode" = "1" ]; then
cat <<EOF
#define BACKGROUND #1d1f21
#define FOREGROUND #c5c8c6

#define COLOR0     #1d1f21
#define COLOR8     #969896

#define COLOR7     #c5c8c6
#define COLOR15    #ffffff
EOF
else
cat <<EOF
#define BACKGROUND #fdfdfd
#define FOREGROUND #1d1f21

#define COLOR0     #fdfdfd
#define COLOR8     #ffffff

#define COLOR7     #1d1f21
#define COLOR15    #969896

EOF
fi

cat <<EOF


#define COLOR1     #cc342b
#define COLOR9     #cc342b

#define COLOR2     #198844
#define COLOR10    #198844

#define COLOR3     #fba922
#define COLOR11    #fba922

#define COLOR4     #3971ed
#define COLOR12    #3971ed

#define COLOR5     #a36ac7
#define COLOR13    #a36ac7

#define COLOR6     #3971ed
#define COLOR14    #3971ed


Xft.dpi: 96
! Xft.dpi: 180
Xft.antialias: true
Xft.hinting: true
Xft.rgba: none
Xft.autohint: false
Xft.hintstyle: hintfull
Xft.lcdfilter: lcddefault

! Enable the extended coloring options
rofi.color-enabled: true
!                  bg       border   separator
rofi.color-window: BACKGROUND, COLOR1, FOREGROUND
!                  bg       fg       bg-alt   hl-bg    hl-fg
rofi.color-normal: COLOR0, COLOR15, COLOR0, BACKGROUND, COLOR3
rofi.color-active: COLOR2, COLOR0, COLOR0, COLOR0, COLOR2
rofi.color-urgent: COLOR0, COLOR5, COLOR0, COLOR0, COLOR5
rofi.separator-style: solid
rofi.sidebar-mode: true
rofi.bw: 1
rofi.columns: 1
rofi.padding: 16

rofi.yoffset: 0
rofi.fake-transparency: false
rofi.location: 0
rofi.width: 50
rofi.font: DroidSansMonoForPowerline Nerd Font Book 9
rofi.lines: 15
rofi.fixed-num-lines: true

! ##### COLORS #####
! special
*foreground:   FOREGROUND
*background:   BACKGROUND
*cursorColor:  FOREGROUND

! black
*color0:       COLOR0
*color8:       COLOR8

! red
*color1:       COLOR1
*color9:       COLOR9

! green
*color2:       COLOR2
*color10:      COLOR10

! yellow
*color3:       COLOR3
*color11:      COLOR11

! blue
*color4:       COLOR4
*color12:      COLOR12

! magenta
*color5:       COLOR5
*color13:      COLOR13

! cyan
*color6:       COLOR6
*color14:      COLOR14

! white
*color7:       COLOR7
*color15:      COLOR15

! ##### END COLORS #####

! # XTerm.vt100.faceName: DroidSansMonoForPowerline Nerd Font Book
! # XTerm.vt100.renderFont: false
! # XTerm*renderFont: true
XTerm*renderFont: true
XTerm*faceName: DroidSansMonoForPowerline Nerd Font
! XTerm*faceName: SauceCodePro Nerd Font
XTerm*faceSize: 10
XTerm*eightBitInput: false
XTerm*selectToClipboard:true
EOF
