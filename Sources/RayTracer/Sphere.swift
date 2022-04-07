import Foundation

class Sphere {
    let center: Point
    let radius: Double
    init(_ c: Point, _ r: Double) {
        self.center = c
        self.radius = r
    }
    func hits(ray r: Ray) -> Bool {
        let oc = r.origin - center
        // ax^2 + bx + c = 0
        let a = r.direction.magnitudeSquared
        let b = 2 * (oc • r.direction)
        let c = oc.magnitudeSquared - pow(radius, 2.0)
        let discriminant = pow(b, 2.0) - 4*a*c
        return (discriminant >= 0)
    }
}
