import Foundation

class CheckerTexture: Texture {
    let colorA: Color
    let colorB: Color
    let hor: Double
    let ver: Double
    let surface: Bool
    init(_ colorA: Color, _ colorB: Color, hor: Double, ver: Double) {
        self.colorA = colorA
        self.colorB = colorB
        self.hor = Double.pi * hor
        self.ver = Double.pi * ver
        self.surface = true
    }
    init(_ colorA: Color, _ colorB: Color, delta: Double) {
        self.colorA = colorA
        self.colorB = colorB
        self.hor = Double.pi / delta
        self.ver = 0
        self.surface = false
    }
    override func value(_ hitRecord: HitRecord) -> Color {
        let sines: Double
        if surface {
            let (u,v) = hitRecord.surfaceCoordinates
            sines = sin(hor*u) * sin(ver*v)
        } else {
            sines = sin(hor*hitRecord.p.x) * sin(hor*hitRecord.p.y) * sin(hor*hitRecord.p.z)
        }
        return sines < 0 ? colorA : colorB
    }
}
