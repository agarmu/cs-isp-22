import Foundation

var rng = SeededRng(seed: 4677910311448980902)

let scene = Scene(
    width: 300,
    aspectRatio: 3/2,
	cam: Camera(lookFrom: [13, 2, 3], lookAt: [0, 0, 0], vUp: Vector(0, 1, 0), vFov: 20, aspectRatio: 3/2, aperture: 0.1, focalDistance: 10),
    objects: generateObjects()
)
scene.scan()


func generateObjects() -> [Hittable] {
	let ground = Lambertian([0.5, 0.5, 0.5])
	let glass = Dielectric(indexOfRefraction: 3/2)
	let glassInner = Dielectric(indexOfRefraction: 2/3)
	var objects: [Hittable] = (-11..<11).flatMap { a in
		(-11..<11).map { b in
			let material: Material
			let center = Point(
                Double(a) + Double.random(in: 0...0.9, using: &rng),
				0.2,
                Double(b) + Double.random(in: 0...0.9, using: &rng)
			)
			// determine material
            let d = Double.random(in: 0...1, using: &rng)
			if d < 0.8 {
				// diffuse
                let albedo = Color.random(in: 0...1, using: &rng) ⊙ Color.random(in: 0...1, using: &rng)
				material = Lambertian(albedo)
			} else if d < 0.95 {
				// metal
                let fuzz = Double.random(in: 0...0.5, using: &rng)
                let albedo = Color.random(in: 0.5...1, using: &rng)
				material = Metal(albedo: albedo, fuzz: fuzz)
			} else {
				// dielectric
				material = glass
			}
			return Sphere(center, 0.2, mat: material)
		}
	}
	objects.append(contentsOf: [
		Sphere([0, -1000, 0], 1000, mat: ground),
		// three large spheres!
		//  	metal
		Sphere([4,1,0], 1, mat: Metal(albedo: [0.7, 0.6, 0.5], fuzz: 0)),
		//   	hollow glass
		Sphere([0, 1, 0], 1, mat: glass), // outer
		Sphere([0, 1, 0], 0.9, mat: glassInner), // inner
		//   	lambertian - brown
		Sphere([-4, 1, 0], 1, mat: Lambertian([0.4, 0.2, 0.1]))
	])
	return objects
}
