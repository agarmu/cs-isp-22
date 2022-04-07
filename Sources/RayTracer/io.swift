//
//  File.swift
//  
//
//  Created by Mukul Agarwal on 4/7/22.
//

import Foundation

extension Scene {
    func export() {
        let tempDir =  URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFile = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("ppm")
        try! ppm().data(using: .utf8)?.write(to: tempFile, options: .atomic)
        #if os(macOS)
        print(tempFile.path)
        executeCmd("/usr/bin/open", "-a", "Preview", tempFile.path)
        #elseif os(Linux)
        let destinationFolder = FileManager().homeDirectoryForCurrentUser.appendingPathComponent("www")
         let destination = destinationFolder.appendingPathComponent("output.png")
         executeCmd("/usr/bin/rm", destination.path)
        executeCmd("/usr/bin/convert", tempFile.path, destination.path)
        executeCmd(
          "/usr/bin/chmod", "-R", "a+rX", destination.path)
        #endif
    }
    fileprivate func ppm() -> String {
        var s = String()
        s.reserveCapacity(width * height * 13 + 21)
        s += "P3\n\(width) \(height)\n255\n"
        for y in 0..<height {
            for x in 0..<width {
                let p = image[x, y]
                s += "\(p.red) \(p.green) \(p.blue) "
            }
            //s += "\n"
        }
        return s
    }
}


fileprivate func executeCmd(_ cmd: String, _ args: String...) {
    let task = Process()
    if #available(macOS 10.13, *) {
        task.executableURL = URL(fileURLWithPath: cmd)
    } else {
        // Fallback on earlier versions
        task.launchPath = cmd
    }
    task.arguments = args
    if #available(macOS 10.13, *) {
        try! task.run()
    } else {
        // Fallback on earlier versions
        task.launch()
    }
    task.waitUntilExit()
}
