class Camera {
    let aspectRatio: Double
    let vpWidth: Double
    let vpHeight: Double
    let origin: Point = [0, 0, 0]
    let focalLength: Double
    lazy var horizontal: Vector = [vpWidth, 0, 0]
    lazy var vertical: Vector = [0, vpHeight, 0]
    lazy var lowerLeftCorner: Vector = origin - horizontal/2 - vertical/2 - [0, 0, focalLength]
    init(vpWidth: Double, vpHeight: Double, focalLength: Double = 1.0) {
        self.vpWidth = vpWidth
        self.vpHeight = vpHeight
        self.aspectRatio = vpWidth / vpHeight
        self.focalLength = focalLength
    }
    init(vpWidth: Double, aspectRatio: Double, focalLength: Double = 1.0) {
        self.vpWidth = vpWidth
        self.aspectRatio = aspectRatio
        self.vpHeight = vpWidth / aspectRatio
        self.focalLength = focalLength
    }
    init(vpHeight: Double, aspectRatio: Double, focalLength: Double = 1.0) {
        self.vpHeight = vpHeight
        self.aspectRatio = aspectRatio
        self.vpWidth = vpHeight * aspectRatio
        self.focalLength = focalLength
    }
    func getRay(_ u: Double, _ v: Double) -> Ray {
        return origin » (lowerLeftCorner + u*horizontal + v*vertical - origin)
    }
}
