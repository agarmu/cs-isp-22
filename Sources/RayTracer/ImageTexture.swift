import SwiftGD
import Foundation

class ImageTexture: Texture {
    let image: Image
    init?(_ imageURL: URL) {
        guard let img = Image(url: imageURL) else {
            return nil
        }
        image = img
    }
    override func value(_ hitRecord: HitRecord) -> Color {
        // clamp u, v to [0, 1]
        var (u, v) = hitRecord.surfaceCoordinates
        u = u.clamp(to: 0...1)
        v = v.clamp(to: 0...1)
        // convert to 'image' coordinates
        let i = min(
            image.size.width-1,
            Int(Double(image.size.width) * u)
        )
        let j = min(
            image.size.height-1,
            Int(Double(image.size.height) * v)
        )
        let pixel = SwiftGD.Point(x: i, y: j)
        fflush(stderr)
        let imageColor = image.get(pixel: pixel)
        return [
            imageColor.redComponent,
            imageColor.greenComponent,
            imageColor.blueComponent
        ]
    }
}
