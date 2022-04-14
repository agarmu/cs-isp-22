import Foundation
class Camera {
	var aspectRatio: Double {
			vpWidth / vpHeight
	}
    let vpWidth: Double
    let vpHeight: Double
    let origin: Point
    let horizontal: Vector
    let vertical: Vector
	let u, v, w: Vector
	init(lookFrom: Point, lookAt: Point, vUp: Point, vFov: Double, aspectRatio: Double) {
		let theta = degreesToRadians(vFov)
		let h = tan(theta/2)
		self.vpHeight = 2.0 * h
		self.vpWidth = aspectRatio * vpHeight
		
		// orthogonal vectors to define coordinate system wrt camera
		let w = (lookFrom - lookAt).normalized()
		let u = (vUp × w).normalized()
		let v = w × u
		
		self.u = u
		self.v = v
		self.w = w
		
		
		origin = lookFrom
		horizontal = vpWidth * u
		vertical = vpHeight * v
    }
    func getRay(_ m: Double, _ n: Double) -> Ray {
        return (origin) »
		(
			(m-0.5)*horizontal + (n-0.5)*vertical - w
		)
    }
}
