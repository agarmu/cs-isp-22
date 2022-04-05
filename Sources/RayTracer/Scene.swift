import SwiftGD
import Foundation

class Scene {
    var image: Image
    var width: Int {
        get {
            return image.size.width
        }
        set {
            image = image.resizedTo(width: newValue) ?? image
        }
    }
    var height: Int {
        get {
            return image.size.height
        }
        set {
            image = image.resizedTo(height: newValue) ?? image
        }
    }
    var aspectRatio : Double {
        Double(width) / Double(height)
    }
            
    init(width: Int, height: Int) {
        image = Image(width: width, height: height)!
    }
    convenience init(width: Int, aspectRatio: Double) {
        let height = Int(Double(width) / aspectRatio)
        self.init(width: width, height: height)
    }
    convenience init(height: Int, aspectRatio: Double) {
        let width = Int(Double(height) / aspectRatio)
        self.init(width: width, height: height)
    }
    func scan() {
        for y in 0..<image.size.height {
            print("Scanlines completed: \(y) of \(image.size.height)", terminator: "\r")
            fflush(stdout)
            for x in 0..<image.size.width {
                let c : Vector =
                  [Double(x), Double(image.size.height-y-1), 0.25] ⊙ [1/Double(image.size.width-1), 1/Double(image.size.height-1), 1]
                image.set(
                  pixel: SwiftGD.Point(x: x, y: y),
                  to: c.color()
                )
            }
        }

    }
    func export() {
        #if os(Linux)
        let destinationFolder = FileManager().homeDirectoryForCurrentUser.appendingPathComponent("www")
        let destination = destinationFolder.appendingPathComponent("output.png")
        executeCmd("/usr/bin/rm", destination.path)
        image.write(to: destination)
        executeCmd(
          "/usr/bin/chmod", "-R", "a+rX", destination.path)
        #endif
    }

}

#if os(Linux)
fileprivate func executeCmd(_ cmd: String, _ args: String...) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: cmd)
    task.arguments = args
    try! task.run()
    task.waitUntilExit()
}
#endif
