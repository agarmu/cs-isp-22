import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
    init(from origin: Point, to direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
    func color() -> Vector {
        let unit = self.direction.normalized()
        let t = 0.5*(unit.y + 1)
        let origin : Vector = [0,0,0]
        return (origin » [1,1,1])[t] + (origin » [0.25,0.7,1])[1-t]

    }
}


extension Ray {
    subscript(t: Double) -> Vector {
        get { origin + t * direction }
    }
}
