#!/bin/bash
set -euo pipefail
# Check if the system is a Mac
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONTFORGE_BIN="/Applications/FontForge.app/Contents/Resources/opt/local/bin/fontforge"
    if [[ ! -x "$FONTFORGE_BIN" ]]; then
        echo "FontForge binary not found in FontForge.app package."
        exit 1
    fi
else
    FONTFORGE_BIN="fontforge"
fi

# Run FontForge with the provided arguments
$FONTFORGE_BIN -lang=ff -c 'Open($1); Generate($2)' sources/Mezenets.sfd sources/Mezenets-Regular.ufo

# Dirty hack to add the openTypeOS2Selection key to the fontinfo.plist file
FONTINFO=`cat sources/Mezenets-Regular.ufo/fontinfo.plist`
echo "${FONTINFO/    <key>openTypeOS2Type<\/key>/    <key>openTypeOS2Selection</key>$'\n'    <array>$'\n'      <integer>7</integer>$'\n'    </array>$'\n'    <key>openTypeOS2Type</key>}" > sources/Mezenets-Regular.ufo/fontinfo.plist

# Create the color data
mkdir sources/Mezenets-Regular.ufo/glyphs.color0/
cp sources/lib.plist sources/Mezenets-Regular.ufo/lib.plist
cp sources/color0.contents.plist sources/Mezenets-Regular.ufo/glyphs.color0/contents.plist
cp sources/layercontents.plist sources/Mezenets-Regular.ufo/layercontents.plist

# list of glyphs that need to be colorized
COLORIZE=( u1C_F_00.glif u1C_F_01.glif u1C_F_02.glif u1C_F_03.glif u1C_F_04.glif u1C_F_05.glif u1C_F_06.glif u1C_F_07.glif u1C_F_08.glif u1C_F_09.glif u1C_F_0A_.glif u1C_F_0B_.glif u1C_F_0C_.glif u1C_F_0D_.glif u1C_F_0E_.glif u1C_F_0F_.glif u1C_F_10.glif u1C_F_11.glif u1C_F_12.glif u1C_F_13.glif u1C_F_14.glif u1C_F_15.glif u1C_F_16.glif u1C_F_17.glif u1C_F_18.glif u1C_F_19.glif u1C_F_1A_.glif u1C_F_1B_.glif u1C_F_1C_.glif u1C_F_1D_.glif u1C_F_1E_.glif u1C_F_1F_.glif u1C_F_20.glif u1C_F_21.glif u1C_F_22.glif u1C_F_23.glif u1C_F_24.glif u1C_F_25.glif u1C_F_26.glif u1C_F_27.glif u1C_F_28.glif u1C_F_29.glif u1C_F_2A_.glif u1C_F_2B_.glif u1C_F_2C_.glif u1C_F_2D_.glif uniE_A_00.glif uniE_A_01.glif uniE_A_02.glif uniE_A_03.glif uniE_A_04.glif uniE_A_05.glif uniE_A_06.glif uniE_A_07.glif uniE_A_08.glif uniE_A_10.glif uniE_A_11.glif uniE_A_12.glif uniE_A_13.glif uniE_A_14.glif uniE_A_15.glif uniE_A_18.glif uniE_A_20.glif uniE_A_21.glif uniE_A_22.glif uniE_A_23.glif uniE_A_24.glif uniE_A_25.glif uniE_A_26.glif uniE_A_27.glif uniE_A_28.glif uniE_A_29.glif uniE_A_2A_.glif uniE_A_2B_.glif uniE_A_2C_.glif uniE_A_2D_.glif uniE_A_30.glif uniE_A_31.glif uniE_A_32.glif uniE_A_33.glif uniE_A_34.glif uniE_A_35.glif uniE_A_36.glif uniE_A_37.glif uniE_A_38.glif uniE_A_39.glif uniE_A_3A_.glif uniE_A_3B_.glif uniE_A_3C_.glif uniE_A_3D_.glif uniE_A_3E_.glif uniE_A_3F_.glif uniE_A_40.glif uniE_A_41.glif uniE_A_2D_.glif uniE_A_42.glif uniE_A_43.glif )
for glif in "${COLORIZE[@]}"; do
    [[ -n "$glif" ]] || continue
    src="sources/Mezenets-Regular.ufo/glyphs/$glif"
    if [[ -e "$src" ]]; then
        cp -- "$src" "sources/Mezenets-Regular.ufo/glyphs.color0/"
    else
        printf 'warning: %s not found\n' "$src" >&2
    fi
done
