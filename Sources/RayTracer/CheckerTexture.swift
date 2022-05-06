import Foundation

class CheckerTexture: Texture {
    let a: Texture
    let b: Texture
    let hor: Double
    let ver: Double
    let surface: Bool
    init(_ a: Texture, _ b: Texture, hor: Double, ver: Double) {
        self.a = a
        self.b = b
        self.hor = Double.pi * hor
        self.ver = Double.pi * ver
        self.surface = true
    }
    convenience init(_ a: Color, _ b: Texture, hor: Double, ver: Double) {
        self.init(SolidTexture(color: a), b, hor: hor, ver: ver)
    }
    convenience init(_ a: Texture, _ b: Color, hor: Double, ver: Double) {
        self.init(a, SolidTexture(color: b), hor: hor, ver: ver)
    }
    convenience init(_ a: Color, _ b: Color, hor: Double, ver: Double) {
        self.init(SolidTexture(color: a), SolidTexture(color: b), hor: hor, ver: ver)
    }
    init(_ a: Texture, _ b: Texture, delta: Double) {
        self.a = a
        self.b = b
        self.hor = Double.pi / delta
        self.ver = 0
        self.surface = false
    }
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
        let sines: Double
        if surface {
            let (u,v) = hitRecord.surfaceCoordinates
            sines = sin(hor*u) * sin(ver*v)
        } else {
            sines = sin(hor*hitRecord.p.x) * sin(hor*hitRecord.p.y) * sin(hor*hitRecord.p.z)
        }
        return sines < 0 ? a.value(hitRecord) : b.value(hitRecord)
    }
}
