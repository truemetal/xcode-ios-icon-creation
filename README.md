### scale_artworks 

**TL;DR - create `@2x` and `@1x` versions for `filename@3x.png` in current folder**

This script looks for @3x.png files in the directory you're running it from, and makes @2x and @1x versions automatically. 

You can place the script into your `/usr/bin` to run it like `scale_artworks.swift`; otherwise specify full/relative path to script e.g. `./scale_artworks.swift`. You can also freely remove `.swift` extension. 

**Usage:**

In terminal, cd to folder with artworks and run `scale_artworks.swift` or copy the script to the folder and run `./scale_artworks.swift`

---

### make_icons

**TL;DR - provide app icon in 1024x1024 and get all the other resolutions**

This tiny script can save you a great deal of time creating `AppIcon.appiconset` icons for your iOS app. Just run the script in your console and it will automatically create icons in all resolutions that you can use in your Xcode iOS project. 

You can place the script into your `/usr/bin` to run it like `make_icons.swift`; otherwise specify full/relative path to script e.g. `./make_icons.swift`. You can also freely remove `.swift` extension. 

**Usage:**

`make_icons.swift <icon_name(s)>`
where icon_name is relative or full path to the file

for Mac app icons supply `-mac` param like so: 
`make_icons.swift -mac <icon_name(s)>`

**Demo of updating all your app icon sizes in less then a minute (.gif, 4.5mb)**

![create app icons demo](https://github.com/truemetal/xcode-ios-icon-creation/blob/master/make_icons%20demo.gif?raw=true)

**Instruction to populate your `AppIcon.appiconset`**

1. Manually copy generated icon files from make_icons output folder to `.appiconset` folder
2. Replace contents of `Contents.json` with contents of [sampleContents.json](sampleContents.json) or [sampleContents macos.json](sampleContents macos.json) and all the icons would be picked up by xcode, no need for dragging and dropping each one individually
3. Enjoy :)
