import Foundation

print("starting")
let scene = Scene(
    width: 400,
    aspectRatio: 16/9,
    objects: [
		Sphere([0,0,-1.5], 0.5, mat: Lambertian([1, 0, 0])),
		Sphere([0,-100.5,-1.5], 100, mat: Lambertian([0.8, 0.8, 0])),
		Sphere([1.0, 0, -1.5], 0.45, mat: Dielectric(indexOfRefraction: 2/3)),
		Sphere([1.0, 0, -1.5], 0.5, mat: Dielectric(indexOfRefraction: 3/2)),
		Sphere([-1.0, 0, -1.5], 0.5, mat: Metal(albedo: [0.2, 0.2, 0.2], fuzz: 0))
    ]
)
scene.scan()
scene.export()



