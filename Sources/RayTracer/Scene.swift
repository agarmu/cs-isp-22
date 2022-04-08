import SwiftImage
import Foundation


class Scene {
    var image: Image<RGBA<UInt8>>
    let objects: [Hittable]
    var width: Int {
        return image.width
    }
    var height: Int {
        return image.height
    }
    var aspectRatio : Double {
        Double(width) / Double(height)
    }
            
    init(width: Int, height: Int, objects: [Hittable] = []) {
        image = Image(width: width, height: height, pixel: .black)
        self.objects = objects
    }
    convenience init(width: Int, aspectRatio: Double, objects: [Hittable] = []) {
        let height = Int(Double(width) / aspectRatio)
        self.init(width: width, height: height, objects: objects)
    }
    convenience init(height: Int, aspectRatio: Double, objects: [Hittable] = []) {
        let width = Int(Double(height) / aspectRatio)
        self.init(width: width, height: height, objects: objects)
    }
    func rayColor(_ r: Ray) -> Vector {
        if let hit = r.lowestHit(objects: objects, time: 0...Double.infinity) {
            return (1+hit.normal)/2.0
        } else {
            let unit = r.direction.normalized()
            let t = 0.5*(unit.y + 1)
            let origin : Vector = [0,0,0]
            return (origin » [1,1,1])[t] + (origin » [0.25,0.7,1])[1-t]
        }
    }
    func scan() {
        let viewH = 2.0
        let viewW = viewH * aspectRatio
        let focalLength = 1.0
        let origin: Point = [0,0,0]
        let horz: Vector = [viewW, 0, 0]
        let vert: Vector = [0, viewH, 0]
        let llcorner = origin - (horz+vert+[0, 0, focalLength*2])/2
        for y in 0..<height {
            for x in 0..<width {
                let u = Double(x)/Double(width-1)
                let v = Double(y)/Double(height-1)
                let ray = origin » (llcorner + u*horz + v*vert - origin)
                image[x,height-1-y] = rayColor(ray).color()
            }
        }
    }
}
