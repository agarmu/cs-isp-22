//
//  Hittable.swift
//  
//
//  Created by Mukul Agarwal on 4/7/22.
//

import Foundation

struct HitRecord {
    let p: Point
    let normal: Vector
    let t: Double
    let frontFace: Bool
    let object: Hittable
    init(p: Point, normal: Vector, t: Double, frontFace: Bool, object: Hittable) {
        self.p = p
        self.normal = normal
        self.t = t
        self.frontFace = frontFace
        self.object = object
    }
    init(ray: Ray, t: Double, outwardNormal: Vector, object: Hittable) {
        self.p = ray[t]
        self.frontFace = (outwardNormal • ray.direction) < 0
        normal = (frontFace ? 1: -1) * outwardNormal
        self.t = t
        self.object = object
    }
}

class Hittable {
	func hit(ray: Ray, time: ClosedRange<Double>) -> HitRecord? {
		fatalError("hitting must be overriden for each hittable")
	}
}
