#!/usr/bin/env xcrun swift
import Foundation
import AppKit

extension String {
    subscript(pos: Int) -> String { return String(characters[startIndex.advancedBy(0)]) }
}

func scaleIcon(iconPath: String, resolution: Int)
{
    let task = NSTask()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath]
    task.launch()
    task.waitUntilExit()
}

func copyAndScaleImage(sourceIconPath: String, desctinationIconPath: String, newResolution: Int) throws
{
    if NSFileManager.defaultManager().fileExistsAtPath(desctinationIconPath) {
        print("icon \((desctinationIconPath as NSString).lastPathComponent) already exists; skipping.")
    }
    else {
        try NSFileManager.defaultManager().copyItemAtPath(sourceIconPath, toPath: desctinationIconPath)
        scaleIcon(desctinationIconPath, resolution: Int(newResolution))
    }
}

// =======

let predicate = NSPredicate(format : "self endswith '@3x.png'")
let filePaths = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(NSFileManager.defaultManager().currentDirectoryPath)

let imagePaths = (filePaths as NSArray).filteredArrayUsingPredicate(predicate)

for filePath in imagePaths as! [String]
{
    if let img = NSImage(contentsOfFile: filePath)
    {
        let icon2xPath = filePath.stringByReplacingOccurrencesOfString("@3x.png", withString: "@2x.png", options: NSStringCompareOptions(rawValue:0), range: nil)
        let icon1xPath = filePath.stringByReplacingOccurrencesOfString("@3x.png", withString: ".png", options: NSStringCompareOptions(rawValue:0), range: nil)
        
        // note: by default, NSImage would assume scale of 3 for @3x images, hence size would be already in points
        let icon1xResolution = Int(img.size.width)
        let icon2xResolution = Int(img.size.width * 2)
        
        try copyAndScaleImage(filePath, desctinationIconPath:icon1xPath, newResolution:icon1xResolution)
        try copyAndScaleImage(filePath, desctinationIconPath:icon2xPath, newResolution:icon2xResolution)
    }
}