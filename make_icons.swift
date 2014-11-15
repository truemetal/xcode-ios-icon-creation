#!/usr/bin/env xcrun swift
import Foundation

let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let defaultSourceIconPath = currentPath.stringByAppendingPathComponent("icon.png")
let iconResolutions = [29, 40, 58, 76, 80, 87, 120, 152, 180]

func outputDirPathForIconPath(iconPath: String) -> String
{
    return iconPath.stringByDeletingLastPathComponent.stringByAppendingPathComponent("\(iconPath.lastPathComponent.stringByDeletingPathExtension)_output")
}

func scaleIcon(iconPath: String, resolution: Int)
{
    let task = NSTask()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath]
    task.launch()
}

func createIconsForFilePaths(filePaths : Array<String>)
{
    var failedInputsCheck = false
    for filePath in filePaths
    {
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) == false {
            failedInputsCheck = true
            println("Issue: file does not exist \(filePath)")
        }
        
        if NSFileManager.defaultManager().fileExistsAtPath(outputDirPathForIconPath(filePath)) {
            failedInputsCheck = true
            println("Issue: this directory exists and will be re-written \(outputDirPathForIconPath(filePath))")
        }
    }
    
    if failedInputsCheck { return }
    
    for iconPath in filePaths
    {
        println("Processing file: \(iconPath)")
        
        let outputDir = outputDirPathForIconPath(iconPath)
        NSFileManager.defaultManager().createDirectoryAtPath(outputDir, withIntermediateDirectories: false, attributes: nil, error: nil)
        
        for resolution in iconResolutions
        {
            let targetIconPath = outputDir.stringByAppendingPathComponent("icon-\(resolution).png")
            NSFileManager.defaultManager().copyItemAtPath(iconPath, toPath: targetIconPath, error:nil)
            
            scaleIcon(targetIconPath, resolution)
        }
    }
}

extension String {
    // string[i] -> one string char
    subscript(pos: Int) -> String { return String(Array(self)[min(self.length-1,max(0,pos))]) }
    var length: Int { return countElements(self) }
}

// =======

if Process.arguments.count > 1
{
    var inputFilenames = Process.arguments
    inputFilenames.removeAtIndex(0)
    
    var filePathsArr = Array<String>()
    
    for filename in inputFilenames
    {
        if filename[0] == "/" {
            filePathsArr.append(filename)
            continue
        }
        
        if filename[0] == "~" {
            filePathsArr.append(filename.stringByExpandingTildeInPath)
            continue
        }
        
        // if we come here, filename should be relative path
        let fileUrl = NSURL(string: filename, relativeToURL: NSURL(fileURLWithPath: currentPath))
        if let u = fileUrl {
            if let p = u.path {
                filePathsArr.append(p)
            }
        }
    }
    
    createIconsForFilePaths(filePathsArr)
}
else
{
    createIconsForFilePaths([defaultSourceIconPath])
}
