#!/usr/bin/env xcrun swift
import Foundation
import AppKit

func scaleIcon(iconPath: String, resolution: Int) {
    let p = Process()
    p.launchPath = "/usr/bin/sips"
    p.arguments = ["-Z", "\(resolution)", iconPath]
    p.launch()
    p.waitUntilExit()
}

func copyAndScaleImage(sourceIconPath: String, desctinationIconPath: String, newResolution: Int) throws {
    if FileManager.default.fileExists(atPath: desctinationIconPath) {
        print("icon \((desctinationIconPath as NSString).lastPathComponent) already exists; skipping.")
    }
    else {
        try FileManager.default.copyItem(atPath: sourceIconPath, toPath: desctinationIconPath)
        scaleIcon(iconPath: desctinationIconPath, resolution: Int(newResolution))
    }
}

// =======

let predicate = NSPredicate(format : "self endswith '@3x.png'")
let filePaths = try FileManager.default.subpathsOfDirectory(atPath: FileManager.default.currentDirectoryPath)

let imagePaths = (filePaths as NSArray).filtered(using: predicate)

for filePath in imagePaths as! [String] {
    if let img = NSImage(contentsOfFile: filePath) {
        let icon2xPath = filePath.replacingOccurrences(of: "@3x.png", with: "@2x.png")
        let icon1xPath = filePath.replacingOccurrences(of: "@3x.png", with: ".png")
        
        // note: by default, NSImage would assume scale of 3 for @3x images, hence size would be already in points
        let icon1xResolution = Int(img.size.width)
        let icon2xResolution = Int(img.size.width * 2)
        
        try copyAndScaleImage(sourceIconPath: filePath, desctinationIconPath: icon1xPath, newResolution: icon1xResolution)
        try copyAndScaleImage(sourceIconPath: filePath, desctinationIconPath: icon2xPath, newResolution: icon2xResolution)
    }
}
