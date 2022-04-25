import Foundation

var rng = SeededRng(seed: 4677910311448980902)

var export: Bool = false
if let v = ProcessInfo.processInfo.environment["EXPORT"] {
    export = v != ""
}

guard
    let earthURL = Resources.earthURL,
    let earthTexture = ImageTexture(earthURL) else {
    fatalError("Unable to load Earth Image from url: \(String(describing: Resources.earthURL))")
}


let scene = Scene(
    width: 1920,
    aspectRatio: 16/9,
    cam: Camera(lookFrom: [13, 2, 3], lookAt: [0, 0, 0], vUp: Vector(0, 1, 0), vFov: 20, aspectRatio: 16/9),
    objects: generateObjects(),
    export: export
)
scene.scan()


func generateObjects() -> [Hittable] {
    let objects: [Hittable] = [
        Sphere(
            [0, -1000, 0],
            1000,
            mat: Lambertian(
                CheckerTexture(
                    [0.216, 0.442, 0.1],
                    [1,1,1],
                    delta: 2
                )
            )
        ),
        Sphere([-4,1,0], 1, mat: Dielectric(indexOfRefraction: 1.5)),
        Sphere([4,1,0], 1, mat: Metal(earthTexture, fuzz: 0.5)),
        Sphere([0,1,0], 1, mat: Metal([0.7, 0.6, 0.5], fuzz: 0.05))
	]
    fflush(stderr)
	return objects
}
