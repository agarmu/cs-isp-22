import SwiftGD
import Foundation

class ImageTexture: Texture {
    let image: Image
    let uTile: Double
    let vTile: Double
    init?(_ imageURL: URL, uTile: Double = 1, vTile: Double = 1) {
        guard let img = Image(url: imageURL) else {
            return nil
        }
        image = img
        self.uTile = uTile
        self.vTile = vTile
    }
    override func value(_ hitRecord: HitRecord) -> Color {
        // clamp u, v to [0, 1] and multiply by tilings
        var (u, v) = hitRecord.surfaceCoordinates
        u = u.clamp(to: 0...1) * vTile
        v = v.clamp(to: 0...1) * uTile
        // modulus u and v by 1 by taking floating part to get 'repeating' tiling
        u = modf(u).1
        v = modf(v).1
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
