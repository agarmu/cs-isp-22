import Foundation

class Sphere: Hittable {
    let center: Point
    let radius: Double
	init(_ c: Point, _ r: Double, mat: Material) {
        self.center = c
        self.radius = r
		super.init(mat)
    }
    override func hit(ray: Ray, time: ClosedRange<Double>) -> HitRecord? {
        let oc = ray.origin - center
        let a = ray.direction.magnitudeSquared
        let hb = oc • ray.direction
        let c = oc.magnitudeSquared - pow(radius, 2.0)
        let disc = pow(hb, 2.0) - a*c
        if disc < 0 {
            return nil
        }
        let sqrtd = sqrt(disc)
        // try the smaller time
        var t = (-hb - sqrtd)/(a)
        if !time.contains(t) {
            // try the other time!
            t = (-hb + sqrtd)/(a)
            guard time.contains(t) else {
                // neither time is available, therefore hit did not occur
                return nil
            }
        }
        // magnitude of vector going from center to sphere surface is radius
        let outwardNormal = (ray[t] - center).normalized()
        return HitRecord(ray: ray, t: t, outwardNormal: outwardNormal, object: self)
    }
    
}
