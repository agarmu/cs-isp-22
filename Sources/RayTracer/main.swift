import Foundation

print("starting")
let scene = Scene(
    width: 400,
    aspectRatio: 16/9,
	cam: Camera(lookFrom: [-2, 2, 1], lookAt: [0, 0, -1], vUp: Vector(0, 1, 0).normalized(), vFov: 20, aspectRatio: 16.0/9.0),
    objects: [
		// ground
		Sphere([0,-100.5,-1], 100, mat: Lambertian([0.8, 0.8, 0])),

		//
		Sphere([0,0,-1], 0.5, mat: Lambertian([0.1, 0.2, 0.5])),
		
		// glass sphere - outer
		Sphere([-1.0, 0, -1], 0.5, mat: Dielectric(indexOfRefraction: 3/2)),
		// glass sphere - hollow inner
		Sphere([-1.0, 0, -1], 0.45, mat: Dielectric(indexOfRefraction: 2/3)),
		
		// metal sphere
		Sphere([1.0, 0, -1], 0.5, mat: Metal(albedo: [0.8, 0.6, 0.2], fuzz: 0))
    ]
)
scene.scan()
scene.export()



