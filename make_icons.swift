#!/usr/bin/env xcrun swift
import Foundation

let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let defaultSourceIconPath = NSURL.fileURLWithPath(currentPath).URLByAppendingPathComponent("icon.png")
let iconResolutions = [29, 40, 48, 50, 55, 57, 58, 60, 72, 76, 80, 87, 88, 100, 114, 120, 144, 152, 167, 171, 172, 180, 196]

func outputDirPathForIconPath(iconPath: NSURL) -> NSURL
{
    let a = iconPath.URLByDeletingPathExtension?.lastPathComponent
    let b = iconPath.URLByDeletingLastPathComponent
    let c = b!.URLByAppendingPathComponent("\(a!)_output")
    return c
}

func scaleIcon(iconPath: NSURL, resolution: Int)
{
    let task = NSTask()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath.path!]
    task.launch()
}

func createIconsForFilePaths(filePaths : Array<NSURL>)
{
    var failedInputsCheck = false
    for filePath in filePaths
    {
        if NSFileManager.defaultManager().fileExistsAtPath(filePath.path!) == false {
            failedInputsCheck = true
            print("Issue: file does not exist \(filePath)")
        }
        
        if NSFileManager.defaultManager().fileExistsAtPath(outputDirPathForIconPath(filePath).absoluteString) {
            failedInputsCheck = true
            print("Issue: this directory exists and will be re-written \(outputDirPathForIconPath(filePath))")
        }
    }
    
    if failedInputsCheck { return }
    
    for iconPath in filePaths
    {
        print("Processing file: \(iconPath)")
        
        let outputDir = outputDirPathForIconPath(iconPath)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(outputDir.absoluteString) {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(outputDir.path!, withIntermediateDirectories: false, attributes: [:])
            } catch {
                print("Error creating image folder")
            }
        }
        
        
        for resolution in iconResolutions
        {
            let targetIconPath = outputDir.URLByAppendingPathComponent("icon-\(resolution).png")
            do {
                try NSFileManager.defaultManager().copyItemAtPath(iconPath.path!, toPath: targetIconPath.path!)
            } catch {
                print("Error copying images")
            }
            
            
            scaleIcon(targetIconPath, resolution: resolution)
        }
    }
}

// =======

if Process.arguments.count > 1
{
    var inputFilenames = Process.arguments
    inputFilenames.removeAtIndex(0)
    
    var filePathsArr = Array<NSURL>()
    
    for filename in inputFilenames
    {
        if filename.characters[filename.startIndex.advancedBy(0)]  == "/" {
            filePathsArr.append(NSURL.fileURLWithPath(filename))
            continue
        }
        
        if filename.characters[filename.startIndex.advancedBy(0)]  == "~" {
            filePathsArr.append(NSURL.fileURLWithPath(filename))
            continue
        }
        
        // if we come here, filename should be relative path
        let fileUrl = NSURL(string: filename, relativeToURL: NSURL(fileURLWithPath: currentPath))
        if let u = fileUrl {
            if let p = u.path {
                filePathsArr.append(NSURL.fileURLWithPath(p))
            }
        }
    }
    
    createIconsForFilePaths(filePathsArr)
}
else
{
    createIconsForFilePaths([defaultSourceIconPath])
}
