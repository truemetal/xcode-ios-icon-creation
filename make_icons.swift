#!/usr/bin/env xcrun swift
import Foundation

let currentPath = FileManager.default.currentDirectoryPath
let defaultSourceIconPath = URL(fileURLWithPath: currentPath).appendingPathComponent("icon.png")
let iphone7AndLaterResolutions = [("iphone-29@2x", 58), ("iphone-29@3x", 87), ("iphone-40@2x", 80), ("iphone-40@3x", 120), ("iphone-60@2x", 120), ("iphone-60@3x", 180)]
let ipad7AndLaterResolutions = [("ipad-29@1x", 29), ("ipad-29@2x", 58), ("ipad-40@1x", 40), ("ipad-40@2x", 80), ("ipad-76@1x", 76), ("ipad-76@2x", 152), ("ipad-83.5@2x", 167)]
let iwatchResolutions = [("iwatch-24@2x", 48), ("iwatch-27.5@2x", 55), ("iwatch-29@2x", 58), ("iwatch-29@3x", 87), ("iwatch-40_all@2x", 80), ("iwatch-44@2x", 88), ("iwatch-86@2x", 172), ("iwatch-98@1x", 196)]
let iphoneNotificationResolutions = [("iphone-notification@2x", 40), ("iphone-notification@3x", 60)]
let ipadNotificationResolutions = [("ipad-notification@1x", 20), ("ipad-notification@2x", 40)]
let macResolutions = [("mac-16", 16), ("mac-16@2x", 32), ("mac-32", 32), ("mac-32@2x", 64), ("mac-128", 128), ("mac-128@2x", 256), ("mac-256", 256), ("mac-256@2x", 512), ("mac-512", 512), ("mac-512@2x", 1024)]
let marketingResolutions = [("iwatch-1024", 1024), ("ios-1024", 1024)]

extension String {
    subscript(pos: Int) -> String {
        guard pos >= 0 && pos < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: pos)])
    }
}

func outputDirPathForIconPath(iconPath: URL) -> URL {
    let iconName = iconPath.deletingPathExtension().lastPathComponent
    let parentPath = iconPath.deletingLastPathComponent()
    return parentPath.appendingPathComponent("\(iconName)_output")
}

func scaleIcon(iconPath: URL, resolution: Int) {
    let task = Process()
    task.launchPath = "/usr/bin/sips"
    task.arguments = ["-Z", "\(resolution)", iconPath.path]
    task.launch()
    task.waitUntilExit()
}

var macMode = false
func createIconsForFilePaths(filePaths : Array<URL>) {
    var failedInputsCheck = false
    for filePath in filePaths {
        if FileManager.default.fileExists(atPath: filePath.path) == false {
            failedInputsCheck = true
            print("Issue: file does not exist \(filePath)")
        }
        
        let outputPath = outputDirPathForIconPath(iconPath: filePath).path
        if FileManager.default.fileExists(atPath: outputPath) {
            _ = try? FileManager.default.removeItem(atPath: outputPath)
        }
    }
    
    if failedInputsCheck { return }
    
    for iconPath in filePaths {
        print("Processing file: \(iconPath)")
        
        let outputDir = outputDirPathForIconPath(iconPath: iconPath)
        
        do {
            try FileManager.default.createDirectory(atPath: outputDir.path, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("Error creating image folder")
        }
        
        if macMode == false {
            makeIconsForResolutionsArr(resolutionsArr: iphone7AndLaterResolutions, iconPath:iconPath, outputDir:outputDir)
            makeIconsForResolutionsArr(resolutionsArr: ipad7AndLaterResolutions, iconPath:iconPath, outputDir:outputDir)
            makeIconsForResolutionsArr(resolutionsArr: iwatchResolutions, iconPath:iconPath, outputDir:outputDir)
            makeIconsForResolutionsArr(resolutionsArr: iphoneNotificationResolutions, iconPath:iconPath, outputDir:outputDir)
            makeIconsForResolutionsArr(resolutionsArr: ipadNotificationResolutions, iconPath:iconPath, outputDir:outputDir)
            makeIconsForResolutionsArr(resolutionsArr: marketingResolutions, iconPath:iconPath, outputDir:outputDir)
        }
        else {
            makeIconsForResolutionsArr(resolutionsArr: macResolutions, iconPath:iconPath, outputDir:outputDir)
        }
    }
}

func makeIconsForResolutionsArr(resolutionsArr:[(String,Int)], iconPath:URL, outputDir:URL) {
    for (prefix, resolution) in resolutionsArr {
        let targetIconPath = outputDir.appendingPathComponent("icon-\(prefix).png")
        do {
            try FileManager.default.copyItem(atPath: iconPath.path, toPath: targetIconPath.path)
        } catch {
            print("Error copying images")
        }
        
        scaleIcon(iconPath: targetIconPath, resolution: resolution)
    }
}

// =======

var arguments = CommandLine.arguments
arguments.remove(at: 0) // remove binary name
arguments = arguments.filter {
    if $0 == "-mac" { macMode = true; return false }
    else { return true }
}

if arguments.count > 1 {
    var filePathsArr = Array<URL>()
    
    for filename in arguments {
        if filename[0]  == "/" {
            filePathsArr.append(URL(fileURLWithPath: filename))
            continue
        }
        
        if filename[0]  == "~" {
            filePathsArr.append(URL(fileURLWithPath: filename))
            continue
        }
        
        // if we come here, filename should be relative path
        let fileUrl = URL(string: filename, relativeTo: URL(fileURLWithPath: currentPath))
        if let u = fileUrl { filePathsArr.append(URL(fileURLWithPath: u.path)) }
    }
    
    createIconsForFilePaths(filePaths: filePathsArr)
}
else {
    createIconsForFilePaths(filePaths: [defaultSourceIconPath])
}
