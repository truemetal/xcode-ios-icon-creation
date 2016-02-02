### make_icons

This tiny script can save you a great deal of time creating icons for your iOS app. Just run the script in your console and it will automatically create icons in all resolutions that you can use in your Xcode iOS project. 

You can place the script into your `/usr/bin` to run it like `make_icons.swift`; otherwise specify full/relative path to script e.g. `./make_icons.swift`. You can also freely remove `.swift` extension. 

**Usage:**

`make_icons.swift <icon_name(s)>`
where icon_name is relative or full path to the file


### scale_artworks 

This script looks for @3x.png files in the directory you're running it from, and makes @2x and @1x versions automatically. 

You can place the script into your `/usr/bin` to run it like `scale_artworks.swift`; otherwise specify full/relative path to script e.g. `./scale_artworks.swift`. You can also freely remove `.swift` extension. 

**Usage:**

In terminal, cd to folder with artworks and run `scale_artworks.swift` or copy the script to the folder and run `./scale_artworks.swift`
