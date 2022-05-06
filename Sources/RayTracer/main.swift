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
    let lightWood = ImageTexture(lightwoodURL),
    let darkWood = ImageTexture(darkwoodURL)
else {
    fatalError("Unable to load image(s)")
    }
// create checkered texture using wood textures
let checkerTexture = CheckerTexture(lightWood, darkWood, hor: 16.0, ver: 8.0)

// create scene
let pt = Vector(0,0,2)
let org = Vector(3, 2, 3)
let scene = Scene(
    width: export ? 600: 300,
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
            [0, -10.5, -1],
        // radius
            10,
            // lambertian = diffuse/matte surface
            mat: Lambertian(checkerTexture)
        ),
       // dielectric = refracts light, indexOfRefraction determines to what extent (using Snell's Law)
        Sphere([0,0,0], 1.0, mat:  Dielectric(indexOfRefraction: 2.5)),
       // textured lambertian surface uses surface coordinates (i.e. latitude/longitude) and maps onto image to create an 'earth' texture
       Sphere([0,0,2], 0.8, mat: Lambertian(earthTexture))
	]
    return objects
}
