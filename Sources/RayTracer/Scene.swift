import SwiftGD
import Foundation

class Scene {
    let image: Image
    init(width: Int, height: Int) {
        image = Image(width: width, height: height)!
    }
    func scan() {
        for y in 0..<image.size.height {
            print("Scanlines completed: \(y) of \(image.size.height)", terminator: "\r")
            fflush(stdout)
            for x in 0..<image.size.width {
                let r = Double(x) / Double(image.size.width-1)
                let g = Double(image.size.height-y-1) / Double(image.size.height-1)
                let b : Double = 0.25
                image.set(
                  pixel: Point(x: x, y: y),
                  to: Color(red: r, green: g, blue: b, alpha: 1)
                )
            }
        }

    }
    func export() {
        let destinationFolder = FileManager().homeDirectoryForCurrentUser.appendingPathComponent("www")
        let destination = destinationFolder.appendingPathComponent("output.png")
        executeCmd("/usr/bin/rm", destination.path)
        image.write(to: destination)
        executeCmd(
          "/usr/bin/chmod", "-R", "a+rX", destination.path)

    }
}


fileprivate func executeCmd(_ cmd: String, _ args: String...) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: cmd)
    task.arguments = args
    try! task.run()
    task.waitUntilExit()
}
