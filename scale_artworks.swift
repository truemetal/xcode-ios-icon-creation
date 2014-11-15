#!/usr/bin/env xcrun swift
import Foundation
import AppKit

func scaleIcon(iconPath: String, resolution: Int)
{
    let task = NSTask()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath]
    task.launch()
}

func copyAndScaleImage(sourceIconPath: String, desctinationIconPath: String, newResolution: Int)
{
    if NSFileManager.defaultManager().fileExistsAtPath(desctinationIconPath) {
        println("icon \(desctinationIconPath.lastPathComponent) already exists; skipping.")
    }
    else {
        NSFileManager.defaultManager().copyItemAtPath(sourceIconPath, toPath: desctinationIconPath, error: nil)
        scaleIcon(desctinationIconPath, Int(newResolution))
    }
}

extension String {
    // string[i] -> one string char
    subscript(pos: Int) -> String { return String(Array(self)[min(self.length-1,max(0,pos))]) }
    var length: Int { return countElements(self) }
}

// =======

func doTheJob()
{
    let predicate = NSPredicate(format : "SELF EndsWith '@3x.png'")
    var filePaths = NSFileManager.defaultManager().subpathsOfDirectoryAtPath(NSFileManager.defaultManager().currentDirectoryPath, error: nil) as NSArray?
    
    if filePaths == nil || predicate == nil { return }
    filePaths = filePaths!.filteredArrayUsingPredicate(predicate!)
    
    for filePath : String in filePaths as Array<String>
    {
        if let img = NSImage(contentsOfFile: filePath)
        {
            let icon2xPath = filePath.stringByReplacingOccurrencesOfString("@3x.png", withString: "@2x.png", options: nil, range: nil)
            let icon1xPath = filePath.stringByReplacingOccurrencesOfString("@3x.png", withString: ".png", options: nil, range: nil)
            
            // note: by default, NSImage would assume scale of 3 for @3x images, hence size would be already in points
            let icon1xResolution = Int(img.size.width)
            let icon2xResolution = Int(img.size.width * 2)
            
            copyAndScaleImage(filePath, icon1xPath, icon1xResolution)
            copyAndScaleImage(filePath, icon2xPath, icon2xResolution)
        }
    }
}

doTheJob()
