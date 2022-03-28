import SwiftGD
import Foundation

let destination =
  FileManager().homeDirectoryForCurrentUser
  .appendingPathComponent("www")
  .appendingPathComponent("output.png")


let scene = Scene(width: 256, height: 256)
for y in 0..<scene.image.size.height {
    for x in 0..<scene.image.size.width {
        let r = Double(x) / Double(scene.image.size.width-1)
        let g = Double(scene.image.size.height-y-1) / Double(scene.image.size.height-1)
        let b : Double = 0.25
        scene.image.set(pixel: Point(x: x, y: y), to: Color(red: r, green: g, blue: b, alpha: 1))
    }
}
executeCmd("/usr/bin/rm", destination.path)
scene.image.write(to: destination)
executeCmd("/usr/bin/chmod", "-R", "a+rX", FileManager().homeDirectoryForCurrentUser.appendingPathComponent("www").path)



func executeCmd(_ cmd: String, _ args: String...) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: cmd)
    task.arguments = args
    try! task.run()
    task.waitUntilExit()
}
