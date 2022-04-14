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
	let lensRadius: Double
	let focalDistance: Double
	//let lowerLeftCorner: Point
	init(lookFrom: Point, lookAt: Point, vUp: Point, vFov: Double, aspectRatio: Double, aperture: Double, focalDistance fDist: Double? = nil) {
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
		
		let focalDistance = fDist ?? (lookAt - lookFrom).magnitude
		
		origin = lookFrom
		horizontal = focalDistance * vpWidth * u
		vertical = focalDistance * vpHeight * v
		//lowerLeftCorner = origin - horizontal/2 - vertical/2 - focalDistance*w
		
		self.lensRadius = (aperture/2).clamp(to: 0.1...10)
		self.focalDistance = focalDistance
    }
    func getRay(_ m: Double, _ n: Double) -> Ray {
		let rd = lensRadius * Vector.randomInUnitDisc()
		let offset = u * rd.x + v * rd.y
        return (origin + offset) »
		(
			(m-0.5)*horizontal + (n-0.5)*vertical - focalDistance*w - offset
		)
    }
}
