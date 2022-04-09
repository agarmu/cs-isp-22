import Foundation

print("starting")
let scene = Scene(
    width: 400,
    aspectRatio: 16/9,
    objects: [
		Sphere([0,0,-1.5], 0.5, mat: Lambertian(albedo: [1, 0, 0])),
		Sphere([0,-100.5,-1.5], 100, mat: Lambertian(albedo: [0.8, 0.8, 0])),
		Sphere([-1.0, 0, -1.5], 0.5, mat: Metal(albedo: [0.2, 0.2, 0.2], fuzz: 0)),
		Sphere([1.0, 0, -1.5], 0.5, mat: Dielectric(indexOfRefraction: 3/2)),
		Sphere([0, 0, -.5], 0.17, mat: Dielectric(indexOfRefraction: -3/2))

    ]
)
scene.scan()
scene.export()



