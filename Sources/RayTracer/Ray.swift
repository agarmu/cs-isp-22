import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
    init(from origin: Point, to direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
    func lowestHit(objects: [Hittable], time: ClosedRange<Double>) -> HitRecord? {
        return objects
            .compactMap {$0.hit(ray: self, time: time)}
            .min {x,y in x.t < y.t}
    }
}


extension Ray {
    subscript(t: Double) -> Vector {
        get { origin + t * direction }
    }
}
