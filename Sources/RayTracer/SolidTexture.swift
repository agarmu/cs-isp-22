class SolidTexture: Texture {
    let color: Color
    init(color: Color) {
        self.color = color
    }
    init(red: Double, green: Double, blue: Double) {
        self.color = [red, green, blue]
    }
    override func value(_ hitRecord: HitRecord) -> Color {
        return color
    }
}
