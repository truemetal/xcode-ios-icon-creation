### scale_artworks 

This script looks for @3x.png files in the directory you're running it from, and makes @2x and @1x versions automatically. 

You can place the script into your `/usr/bin` to run it like `scale_artworks.swift`; otherwise specify full/relative path to script e.g. `./scale_artworks.swift`. You can also freely remove `.swift` extension. 

**Usage:**

In terminal, cd to folder with artworks and run `scale_artworks.swift` or copy the script to the folder and run `./scale_artworks.swift`

### make_icons

This tiny script can save you a great deal of time creating `AppIcon.appiconset` icons for your iOS app. Just run the script in your console and it will automatically create icons in all resolutions that you can use in your Xcode iOS project. 

You can place the script into your `/usr/bin` to run it like `make_icons.swift`; otherwise specify full/relative path to script e.g. `./make_icons.swift`. You can also freely remove `.swift` extension. 

**Usage:**

`make_icons.swift <icon_name(s)>`
where icon_name is relative or full path to the file

**A shortcut to populate your `AppIcon.appiconset`**

1. Manually copy generated icon files from make_icons output folder to `.appiconset` folder
2. Replace contents of `Contents.json` with the following and all the icons would be picked up by xcode, no need for dragging and dropping each one individually
3. Enjoy :)

```
{
  "images" : [
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "icon-iphone-29@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "icon-iphone-29@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "icon-iphone-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "icon-iphone-40@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "icon-iphone-60@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "icon-iphone-60@3x.png",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "icon-ipad-29@1x.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "icon-ipad-29@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "icon-ipad-40@1x.png",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "icon-ipad-40@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "icon-ipad-76@1x.png",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "icon-ipad-76@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "83.5x83.5",
      "idiom" : "ipad",
      "filename" : "icon-ipad-83.5@2x.png",
      "scale" : "2x"
    },
    {
      "size" : "24x24",
      "idiom" : "watch",
      "filename" : "icon-iwatch-24@2x.png",
      "scale" : "2x",
      "role" : "notificationCenter",
      "subtype" : "38mm"
    },
    {
      "size" : "27.5x27.5",
      "idiom" : "watch",
      "filename" : "icon-iwatch-27.5@2x.png",
      "scale" : "2x",
      "role" : "notificationCenter",
      "subtype" : "42mm"
    },
    {
      "size" : "29x29",
      "idiom" : "watch",
      "filename" : "icon-iwatch-29@2x.png",
      "role" : "companionSettings",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "watch",
      "filename" : "icon-iwatch-29@3x.png",
      "role" : "companionSettings",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "watch",
      "filename" : "icon-iwatch-40_all@2x.png",
      "scale" : "2x",
      "role" : "appLauncher",
      "subtype" : "38mm"
    },
    {
      "size" : "44x44",
      "idiom" : "watch",
      "filename" : "icon-iwatch-44@2x.png",
      "scale" : "2x",
      "role" : "longLook",
      "subtype" : "42mm"
    },
    {
      "size" : "86x86",
      "idiom" : "watch",
      "filename" : "icon-iwatch-86@2x.png",
      "scale" : "2x",
      "role" : "quickLook",
      "subtype" : "38mm"
    },
    {
      "size" : "98x98",
      "idiom" : "watch",
      "filename" : "icon-iwatch-98@1x.png",
      "scale" : "2x",
      "role" : "quickLook",
      "subtype" : "42mm"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
```
