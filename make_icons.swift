#!/usr/bin/env xcrun swift
import Foundation

let iconCreatorFolder = NSFileManager.defaultManager().currentDirectoryPath
let sourceIcon = iconCreatorFolder.stringByAppendingPathComponent("icon.png")
let outputDir = iconCreatorFolder.stringByAppendingPathComponent("output")
let iconResolutions = [29, 40, 58, 76, 80, 87, 120, 152, 180]

func scaleIcon(iconPath: String, resolution: Int)
{
    let task = NSTask()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath]
    task.launch()
}

if NSFileManager.defaultManager().fileExistsAtPath(iconCreatorFolder) == false
{
    println("Icon creation folder does not exist!")
}
else
{
    if NSFileManager.defaultManager().fileExistsAtPath(outputDir) {
        NSFileManager.defaultManager().removeItemAtPath(outputDir, error: nil)
    }
    
    NSFileManager.defaultManager().createDirectoryAtPath(outputDir, withIntermediateDirectories: false, attributes: nil, error: nil)
    
    for resolution in iconResolutions
    {
        let targetIconPath = outputDir.stringByAppendingPathComponent("icon-\(resolution).png")
        NSFileManager.defaultManager().copyItemAtPath(sourceIcon, toPath: targetIconPath, error:nil)
        
        scaleIcon(targetIconPath, resolution)
    }
}
