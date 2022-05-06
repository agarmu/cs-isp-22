import Foundation

// seeded rng for multiple renderings with single 'randomly' generated layout of objects
var rng = SeededRng(seed: 4677910311448980902)

// if the export setting is turned on, the scene will be larger and require more rays per pixel
var export: Bool = false
if let v = ProcessInfo.processInfo.environment["EXPORT"] {
    export = v != ""
}

// load image-based textures
guard
    let earthURL = Resources.earthURL,
    let lightwoodURL = Resources.lightwoodURL,
    let darkwoodURL = Resources.darkwoodURL,
    let earthTexture = ImageTexture(earthURL),
    let lightWood = ImageTexture(lightwoodURL, uTile: 15, vTile: 15),
    let darkWood = ImageTexture(darkwoodURL, uTile: 15, vTile: 15)
else {
    fatalError("Unable to load image(s)")
    }
// create checkered texture using wood textures
let checkerTexture = CheckerTexture(lightWood, darkWood, delta: 4.0)

// create scene
let pt = ([1.5, 0, 1.5] + [0,0,-1])/2.0 + [0, -1, 0]
let org = Vector(8, 2, -10)
let scene = Scene(
    width: 600,
    aspectRatio: 3/2,
    cam: Camera(lookFrom: org, lookAt: pt, vUp: Vector(0, 1, 0), vFov: 20, aspectRatio: 3/2, aperture: 0.0),
    objects: generateObjects(),
    export: export
)
scene.scan()


// create objects, each with different properties
func generateObjects() -> [Hittable] {
    let objects: [Hittable] = [
       Sphere(
        // center
        [0, -100, 0] + [0, -1, 0],
        // radius
            100,
            // lambertian = diffuse/matte surface
            mat: Metal(checkerTexture, fuzz: 0.5)
        ),
       // dielectric = refracts light, indexOfRefraction determines to what extent (using Snell's Law)
        Sphere([0,0,2], 1.0, mat:  Metal([250,181,237] / 255.0, fuzz: 0.3)),
       // textured lambertian surface uses surface coordinates (i.e. latitude/longitude) and maps onto image to create an 'earth' texture
       Sphere([0,0,-1], 1.0, mat: Lambertian(earthTexture)),
       Sphere([2.0, 0, 0], 1.0, mat: Dielectric(indexOfRefraction: 2.5))
	]
    return objects
}
