# Mezenets Typeface

Mezenets is a font for typesetting Znamenny Notation.

![Sample Image](documentation/image2.png)

The font is named after Alexander Mezenets, a 17th-century Orthodox monk, musical theorist, scribe, and editor who led efforts to standardize and reform Znamenny chant notation, authoring the influential treatise *Азбука знаменного пения (Извещение о согласнейших пометах)* (c.1668–1670) that formalized the 12-step pitch system and practical signs used in printed chant books.

Mezenets provides all of the necessary characters for typesetting music in Znamenny Notation, as used since the seventeenth century, with or without priznaki, and in Kazan Notation used for Put / Demestvenny chant.
The font also provides a set of Cyrillic characters
borrowed from the [Vilnius font](https://github.com/slavonic/Vilnius), but modified to fit the vertical metrics of the neumes. These Cyrillic characters are not intended for typesetting standalone Church Slavonic texts, but only lyrics in Znamenny musical scores in software settings where different fonts cannot be specified for lyrics.

## History

Mezenets was designed by Nikita Simmons in the early 1990s in Altsys (later Macromedia) Fontographer for a legacy codepage.
It was reencoded for Unicode by Aleksandr Andreev and Nikita Simmons
as part of the [proposal to add Znamenny Notation to the Unicode standard](https://www.ponomar.net/files/palaeoslavic.pdf), who also added OpenType features and color functionality and reworked the font for inclusion in Google Fonts.

## License

This Font Software is licensed under the SIL Open Font License,
Version 1.1. This license is available with a FAQ at
[https://openfontlicense.org/](https://openfontlicense.org/).

## Building the Fonts

The font source is stored in a FontForge SFD file in the `sources/` directory. All modifications should be made in FontForge, resulting in an updated SFD file. This file is then converted to UFO format by running the `convert.sh` script. From terminal:

```
cd your/local/project/directory
./convert.sh
```

Since FontForge does not natively support COLR/CPAL, the `convert.sh` script also creates some additional UFO files for the color functionality. This is presently buggy and may be changed in the future.

The font can then be built using fontmake and gftools by running:

```
make build
```

Note that this requires Python and will install all of the necessary libraries and tools into a virtualenv at `venv/`.

To delete the virtualenv and the results of the build, run:

```
make clean
```

To build the sample image the sits at the top of this README, run:

```
make images
```

The command `make update` updates the repository and Python dependencies and should be run periodically.

Google's master repository also had a GitHub workflow for building the fonts in the cloud on push, but this seems to always fail because of incorrect dependencies, so it has been disabled. Instead, built binaries are stored on GitHub in the `fonts/` directory.

Because Google Fonts does not correctly support OTF fonts with color, only TTF and WOFF formats are built.

## Features

The font uses COLR/CPAL v.0 for rendering cinnabar marks in red (actually, the shade is #CC0803). Support for this functionality is presently available in the latest versions of LibreOffice and Microsoft Office as well as in most up-to-date [web browsers](https://caniuse.com/?search=colr-v0). COLR/CPAL is not supported in XeTeX and LuaTeX, but you can use the [churchslavonic TeX package](https://ctan.org/pkg/churchslavonic) to automatically color the cinnabar marks in LuaTeX instead. COLR/CPAL is generally [not supported in LilyPond](https://lilypond.org/doc/v2.25/Documentation/notation/fonts), MuseScore, Finale, or other music notation software. In such software the font will render in monochrome.

The font provides a number of alternative glyph shapes, accessible via Stylistic Alternates (*salt* feature). See the [documentation in PDF format](https://www.ponomar.net/files/fonts-znam.pdf) for details.

The font also provides four stylistic sets (features *ss01* through *ss04*):
* Stylistic Set 1 (*ss01*) Old-style Demestvenny. This stylistic set turns on kerning rules that force adjoining neumes to make ligatures, as is customary in Demestvenny Notation. At the same time, the Zanozhek, Mechik, and other neumes are typeset in the old style, commonly found in the manuscript tradition.

* Stylistic Set 2 (*ss02*) New-style Demestvenny. This stylistic set turns on kerning rules that force adjoining neumes to make ligatures, as is customary in Demestvenny Notation. The Zanozhek, Mechik, and other neumes are typeset in the new style, as used in the publications of Kalashnikov.

* Stylistic Set 3 (*ss03*) New-style Contracted Demestvenny. This stylistic set turns on additional kerning rules that force some adjoining neumes to make contracted ligatures. The Zanozhek, Mechik, and other neumes are typeset in the new style, as used in the publications of Kalashnikov.

* Stylistic Set 4 (*ss04*) Render cinnabar marks in black. This stylistic set turns off the coloring of cinnabar marks as specified by the COLR / CPAL tables and renders the glyphs in monochrome. 

Please take a look at the the additional documentation in [PDF format](https://www.ponomar.net/files/fonts-znam.pdf).

## Regression testing

The font is quite complex because of the various ligatures and multiple layers of diacritical marks controlled by anchor points, not to mention the use of color. If you change anything in the font, you must run the regression tests and make sure that the OpenType features have not been corrupted:

```
make regtests
```

This creates a file called `test-results.pdf` that displays the results of the tests. Note that running the regression tests requires LuaTeX and ImageMagick and takes a long time. It will compare your results against the baseline files used for regression testing, stored in `regtests/baseline/`.

Note that the baseline files are created using the command:

```
make baseline
```

but you should only do that if you are the project maintainer.

## More Znamenny Fonts and Tooling

See the [main repository](https://github.com/slavonic/fonts-znam/) and the [website](https://sci.ponomar.net/music.html).