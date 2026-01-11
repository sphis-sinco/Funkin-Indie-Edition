# 1.9 (1/11/2026)
## Fixed
- Fixed Song inst caching not being threaded
- The engine now compiles with the latest libraries

## Added
- Added new `properties` field to character JSONS
    - Has a `packer` field, a booelean that tells if you're using a packer atlas, so it's for spirit.
    - Has a `pixel` field, a booelean that tells if its a pixel stage character
    - Has a `scale_addition` field, a float that adds to the character scale
    - Has a `flipX` field, a boolean that flips the sprite horizontally
- Added hmm file (for ez installing of libraries)

## Changed
- Pressing your RESET key in freeplay with repopulate the song data
- Freeplay songdata population now only happens if when entering freeplay there is no song data to be found
- Song pitching works with non-cpp platforms now
- Converted all characters to character JSONS!
- Changed location of character offset files to `assets/data/characters/`
- Changed the window title to "Kade Engine Continued"
- Rebranded to "Kade Engine Continued"
