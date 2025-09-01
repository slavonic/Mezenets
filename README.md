# Mezenets Typeface

Mezenets is a font for typesetting Znamenny Notation with or without priznaki.

![Sample Image](documentation/image2.png)

Mezenets uses COLR/CPAL v.0. The cinnabar marks are rendered in #CC0803 and the
neumes and black marks are black. The font provides a set of Cyrillic characters
borrowed from the [Vilnius font](https://github.com/slavonic/Vilnius), but modified to fit the metrics of the neumes.
Note that because black has been hardcoded into the CPAL table, it is not possible
to modify the text color in your text editing software. This will be fixed in a later version of the font that uses COLR/CPAL v.1.

## History

Mezenets was designed by Nikita Simmons in ... for a legacy codepage.
It was reencoded for Unicode by Aleksandr Andreev and Nikita Simmons
as part of the [proposal to add Znamenny Notation to the Unicode standard](https://www.ponomar.net/files/palaeoslavic.pdf).

## License

This Font Software is licensed under the SIL Open Font License,
Version 1.1. This license is available with a FAQ at
[https://openfontlicense.org/](https://openfontlicense.org/).

## Building the Fonts

The font source is stored in a FontForge SFD file in the `sources/` directory. All modifications should be made in FontForge, resulting in an updated SFD file. This file is then converted to UFO format by running the convert script. From terminal:

```
cd your/local/project/directory
./convert.sh
```

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

The commands `make update` and `make update-project-template` update the repository structure and Python dependencies and should be run periodically.

Google's master repository also had a GitHub workflow for building the fonts in the cloud on push, but this seems to always fail because of incorrect dependencies, so has been disabled. Instead, built binaries are stored on GitHub in the `fonts/` directory.

## Features

Add this section.

There is some documentation in [PDF format](https://www.ponomar.net/files/fonts-znam.pdf).

## Regression testing

The font is quite complex because of the various ligatures and multiple layers of diacritical marks controlled by anchor points. If you change anything in the font, be sure to run the regression tests and make sure that the OpenType features have not been corrupted:

```
make regtests
```

This creates a the file `test-results.pdf` that displays the results of the tests. Note that running the regression tests requires LuaLatex and ImageMagick. To create the baseline files that are used for the regression testing, stored in `regtests/baseline/`, run:

```
make baseline
```

Note that you should only do that if you are absolutely sure that the changes you made to GSUB and GPOS features are correct.

## More Znamenny Fonts

See the [main repository](https://github.com/slavonic/fonts-znam/) and the [website](https://sci.ponomar.net/music.html).