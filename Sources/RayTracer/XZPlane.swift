

class XZPlane: Hittable {
    let k: Double
    let xBound: ClosedRange<Double>
    let zBound: ClosedRange<Double>
    init(_ k: Double, x: ClosedRange<Double>, z: ClosedRange<Double>, mat: Material) {
        self.k = k
        self.xBound = x
        self.zBound = z
        super.init(mat)
    }
    func surfaceCoordinates(p: Point) -> (u: Double, v: Double) {
        return (
            u: (p.x - xBound.lowerBound)/(xBound.upperBound - xBound.lowerBound),
            v: (p.z - zBound.lowerBound)/(zBound.upperBound - zBound.lowerBound)
        )
    }
    override func hit(ray: Ray, time: ClosedRange<Double>) -> HitRecord? {
        var t: Double = 0
        if ray.origin.y != k && ray.direction.y == 0 {
            return nil
        }
        // k = (direction.y)*t + origin.y
        t = (k - ray.origin.y)/ray.direction.y
        let p = ray[t]
        guard xBound.contains(p.x) && zBound.contains(p.z) && abs(p.y - k) < 0.005 else {
            return nil
        }
        return HitRecord(
            ray: ray,
            t: t,
            outwardNormal: [0,0,0],
            object: self,
            surfaceCoordinates: surfaceCoordinates(p: p)
        )
    }
}
