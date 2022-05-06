import Foundation
struct Camera {
	var aspectRatio: Double {
			vpWidth / vpHeight
	}
    let vpWidth: Double
    let vpHeight: Double
    let origin: Point
    let horizontal: Vector
    let vertical: Vector
	let u, v, w: Vector
    let focalDistance: Double
    let lensRadius: Double
    init(lookFrom: Point, lookAt: Point, vUp: Point, vFov: Double, aspectRatio: Double, aperture: Double = 0, focalDistance: Double) {
		let theta = degreesToRadians(vFov)
		let h = tan(theta/2)
		self.vpHeight = 2.0 * h
		self.vpWidth = aspectRatio * vpHeight
		
		// orthogonal vectors to define coordinate system wrt camera
		let w = (lookFrom - lookAt).normalized()
		let u = (vUp × w).normalized()
		let v = w × u
		// initialize u, v, and w orthogonal vector properties
        
        // cannot directly use self.u = <formula> because all
        // props must be initialized before any are used
		self.u = u
		self.v = v
		self.w = w
		
        // initialize vectors with focal distance
		origin = lookFrom
		horizontal = focalDistance * vpWidth * u
		vertical = focalDistance * vpHeight * v
        
        self.lensRadius = aperture / 2.0
        self.focalDistance = focalDistance
    }
    init(lookFrom: Point, lookAt: Point, vUp: Point, vFov: Double, aspectRatio: Double, aperture: Double = 0) {
        let fd = (lookAt - lookFrom).magnitude
        self.init(lookFrom: lookFrom, lookAt: lookAt, vUp: vUp, vFov: vFov, aspectRatio: aspectRatio, aperture: aperture, focalDistance: fd)
    }
    func getRay(_ m: Double, _ n: Double) -> Ray {
        let rd = lensRadius * Vector.randomInUnitDisc()
        let offset = u * rd.x + v * rd.y
        return (origin) »
		(
			(m-0.5)*horizontal + (n-0.5)*vertical - focalDistance*w - offset
		)
    }
}
