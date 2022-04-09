import Darwin
class Camera {
	var aspectRatio: Double {
			vpWidth / vpHeight
	}
    let vpWidth: Double
    let vpHeight: Double
    let origin: Point
    let horizontal: Vector
    let vertical: Vector
    let lowerLeftCorner: Point
	
	init(lookFrom: Point, lookAt: Point, vUp: Point, vFov: Double, aspectRatio: Double) {
		let theta = degreesToRadians(vFov)
		let h = tan(theta/2)
		self.vpHeight = 2.0 * h
		self.vpWidth = aspectRatio * vpHeight
		
		// orthogonal vectors to define coordinate system wrt camera
		let w = (lookFrom - lookAt).normalized()
		let u = (vUp × w).normalized()
		let v = w × u
		origin = lookFrom
		horizontal = vpWidth * u
		vertical = vpHeight * v
		lowerLeftCorner = origin - horizontal/2 - vertical/2 - w
    }
    func getRay(_ u: Double, _ v: Double) -> Ray {
        return origin » (lowerLeftCorner + u*horizontal + v*vertical - origin)
    }
}
