import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
    init(from origin: Point, to direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
}
