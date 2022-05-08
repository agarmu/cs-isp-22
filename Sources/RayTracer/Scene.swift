import SwiftImage
import Foundation

struct Scene {
    let objects: [Hittable]
    let samplesPerPixel: Int
    let maxDepth: Int = 30
    let cam: Camera
    let width: Int
    let height: Int
    var aspectRatio : Double {
        Double(width) / Double(height)
    }
            
    init(width: Int, height: Int, cam: Camera, objects: [Hittable] = [], export: Bool) {
        self.width = width
        self.height = height
        self.objects = objects
		self.cam = cam
        if export {
            self.samplesPerPixel = 30
        } else {
            self.samplesPerPixel = 1
        }

    }
    init(width: Int, aspectRatio: Double, cam: Camera, objects: [Hittable] = [], export: Bool) {
        let height = Int(Double(width) / aspectRatio)
        self.init(width: width, height: height, cam: cam, objects: objects, export: export)
    }
    init(height: Int, aspectRatio: Double, cam: Camera, objects: [Hittable] = [], export: Bool) {
        let width = Int(Double(height) / aspectRatio)
        self.init(width: width, height: height, cam: cam, objects: objects, export: export)
    }
    func rayColor(_ r: Ray, depth: Int) -> Vector {
        if depth <= 0 {
            return [0, 0, 0]
        } else if let hit = r.lowestHit(objects: objects, time: 0.001...Double.infinity) {
			let (attenuation, scattered) = hit.scatter()
			if let scattered = scattered {
				return attenuation ⊙ rayColor(scattered, depth: depth-1)
			} else {
				return [0,0,0]
			}
        } else {
            let unit = r.direction.normalized()
            let t = 0.5*(unit.y + 1)
            return lerp([0.25,0.7,1], [1,1,1], by: t)
        }
    }
    func scan() {
        print("P3\n\(width) \(height)\n65535")
        for y in (0..<height).reversed() {
            for x in 0..<width {
                var pixel: Vector = [0,0,0]
                for _ in 0..<samplesPerPixel {
                    let u = (Double(x) + Double.random(in: -0.5...0.5))/Double(width-1)
                    let v = (Double(y) + Double.random(in: -0.5...0.5))/Double(height-1)
                    let ray = cam.getRay(u, v)
                    pixel += rayColor(ray, depth: self.maxDepth)
                }
                pixel /= max(1.0, Double(samplesPerPixel))
                pixel = pixel.gamma(2)
                print(pixel.ppm())
            }
			fputs("Scanlines left: \(y)\u{001B}[0K\r", stderr)
			fflush(stderr)
        }

        fputs("Done scanning \(height) lines.\u{001B}[0K\n", stderr)
        fflush(stderr)
    }
}
