#!/usr/bin/env xcrun swift
import Foundation

let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let defaultSourceIconPath = NSURL.fileURLWithPath(currentPath).URLByAppendingPathComponent("icon.png")
let iphone7AndLaterResolutions = [("iphone-29@2x", 58), ("iphone-29@3x", 87), ("iphone-40@2x", 80), ("iphone-40@3x", 120), ("iphone-60@2x", 120), ("iphone-60@3x", 180)]
let ipad7AndLaterResolutions = [("ipad-29@1x", 29), ("ipad-29@2x", 58), ("ipad-40@1x", 40), ("ipad-40@2x", 80), ("ipad-76@1x", 76), ("ipad-76@2x", 152), ("ipad-83.5@2x", 167)]
let iwatchResolutions = [("iwatch-24@2x", 48), ("iwatch-27.5@2x", 55), ("iwatch-29@2x", 58), ("iwatch-29@3x", 87), ("iwatch-40_all@2x", 80), ("iwatch-44@2x", 88), ("iwatch-86@2x", 172), ("iwatch-98@1x", 196)]
let macResolutions = [("mac-16", 16), ("mac-16@2x", 32), ("mac-32", 32), ("mac-32@2x", 64), ("mac-128", 128), ("mac-128@2x", 256), ("mac-256", 256), ("mac-256@2x", 512), ("mac-512", 512), ("mac-512@2x", 1024)]

extension String {
    subscript(pos: Int) -> String { return String(characters[startIndex.advancedBy(0)]) }
}

func outputDirPathForIconPath(iconPath: NSURL) -> NSURL
{
    let iconName = iconPath.URLByDeletingPathExtension?.lastPathComponent
    let parentPath = iconPath.URLByDeletingLastPathComponent
    return parentPath!.URLByAppendingPathComponent("\(iconName!)_output")
}

func scaleIcon(iconPath: NSURL, resolution: Int)
{
    let task = NSTask()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath.path!]
    task.launch()
    task.waitUntilExit()
}

var macMode = false
func createIconsForFilePaths(filePaths : Array<NSURL>)
{
    var failedInputsCheck = false
    for filePath in filePaths
    {
        if NSFileManager.defaultManager().fileExistsAtPath(filePath.path!) == false {
            failedInputsCheck = true
            print("Issue: file does not exist \(filePath)")
        }
        
        if NSFileManager.defaultManager().fileExistsAtPath(outputDirPathForIconPath(filePath).path!) {
            failedInputsCheck = true
            print("Issue: this directory exists and will be re-written \(outputDirPathForIconPath(filePath))")
        }
    }
    
    if failedInputsCheck { return }
    
    for iconPath in filePaths
    {
        print("Processing file: \(iconPath)")
        
        let outputDir = outputDirPathForIconPath(iconPath)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(outputDir.path!, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("Error creating image folder")
        }
        
        if macMode == false 
        {
			makeIconsForResolutionsArr(iphone7AndLaterResolutions, iconPath:iconPath, outputDir:outputDir)
			makeIconsForResolutionsArr(ipad7AndLaterResolutions, iconPath:iconPath, outputDir:outputDir)
			makeIconsForResolutionsArr(iwatchResolutions, iconPath:iconPath, outputDir:outputDir)
        }
        else {
        	makeIconsForResolutionsArr(macResolutions, iconPath:iconPath, outputDir:outputDir)
        }
    }
}

func makeIconsForResolutionsArr(resolutionsArr:[(String,Int)], iconPath:NSURL, outputDir:NSURL)
{
    for (prefix, resolution) in resolutionsArr
    {
        let targetIconPath = outputDir.URLByAppendingPathComponent("icon-\(prefix).png")
        do {
            try NSFileManager.defaultManager().copyItemAtPath(iconPath.path!, toPath: targetIconPath.path!)
        } catch {
            print("Error copying images")
        }
        
        scaleIcon(targetIconPath, resolution: resolution)
    }
}

// =======

var arguments = Process.arguments
arguments.removeAtIndex(0) // remove binary name
arguments = arguments.filter { if $0 == "-mac" { macMode = true; return false } else { return true } }

if arguments.count > 1
{
    var filePathsArr = Array<NSURL>()
    
    for filename in arguments
    {
        if filename[0]  == "/" {
            filePathsArr.append(NSURL.fileURLWithPath(filename))
            continue
        }
        
        if filename[0]  == "~" {
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