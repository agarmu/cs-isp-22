import Foundation

class CheckerTexture: Texture {
    let a: Texture
    let b: Texture
    let hor: Double
    let ver: Double
    let surface: Bool
    // original initializer - creates checkered texture that alternates between two textures
    // this uses surface (u,v) coordinates to create renderings
    init(_ a: Texture, _ b: Texture, hor: Double, ver: Double) {
        self.a = a
        self.b = b
        self.hor = Double.pi * hor
        self.ver = Double.pi * ver
        self.surface = true
    }
    // several 'convenience' initializers that allow one to pass a Color directly instead of a SolidTexture() wrapper around it
    convenience init(_ a: Color, _ b: Texture, hor: Double, ver: Double) {
        self.init(SolidTexture(color: a), b, hor: hor, ver: ver)
    }
    convenience init(_ a: Texture, _ b: Color, hor: Double, ver: Double) {
        self.init(a, SolidTexture(color: b), hor: hor, ver: ver)
    }
    convenience init(_ a: Color, _ b: Color, hor: Double, ver: Double) {
        self.init(SolidTexture(color: a), SolidTexture(color: b), hor: hor, ver: ver)
    }
    // original initializer - this uses the coordinates of the *point* of contact to alternate betwen the textures
    init(_ a: Texture, _ b: Texture, delta: Double) {
        self.a = a
        self.b = b
        self.hor = Double.pi / delta
        self.ver = 0
        self.surface = false
    }
    // several 'convenience' initializers that allow one to pass a Color directly instead of a SolidTexture() wrapper around it
    convenience init(_ a: Color, _ b: Texture, delta: Double) {
        self.init(SolidTexture(color: a), b, delta: delta)
    }
    convenience init(_ a: Texture, _ b: Color, delta: Double) {
        self.init(a, SolidTexture(color: b), delta: delta)
    }
    convenience init(_ a: Color, _ b: Color, delta: Double) {
        self.init(SolidTexture(color: a), SolidTexture(color: b), delta: delta)
    }
    override func value(_ hitRecord: HitRecord) -> Color {
        // determine which texture to use, then call its value() function
        let sines: Double
        if surface {
            // use surface coordinates to create rendering
            let (u,v) = hitRecord.surfaceCoordinates
            // multiply by 'hor' and 'ver' to scale by direction
            sines = sin(hor*u) * sin(ver*v)
        } else {
            // use contact point
            // only 'hor' is used as the scaling factor, since it is equal in all directions
            sines = sin(hor*hitRecord.p.x) * sin(hor*hitRecord.p.y) * sin(hor*hitRecord.p.z)
        }
        return sines < 0 ? a.value(hitRecord) : b.value(hitRecord)
    }
}
