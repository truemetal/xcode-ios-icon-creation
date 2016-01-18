#!/usr/bin/env xcrun swift
import Foundation

let currentPath = NSFileManager.defaultManager().currentDirectoryPath
let defaultSourceIconPath = NSURL.fileURLWithPath(currentPath).URLByAppendingPathComponent("icon.png")
let iconResolutions = [29, 40, 48, 50, 55, 57, 58, 60, 72, 76, 80, 87, 88, 100, 114, 120, 144, 152, 167, 171, 172, 180, 196]

extension String { subscript(pos: Int) -> String { return String(characters[startIndex.advancedBy(0)]) } }

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