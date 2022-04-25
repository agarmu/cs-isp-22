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
	let ray: Ray
    // Surface Coordinates for texturing
    let surfaceCoordinates : (u: Double, v: Double)
    init(ray: Ray, t: Double, outwardNormal: Vector, object: Hittable, surfaceCoordinates: (u: Double, v: Double)) {
		self.ray = ray
        self.p = ray[t]
        self.frontFace = (outwardNormal • ray.direction) < 0
        normal = (frontFace ? 1: -1) * outwardNormal
        self.t = t
        self.object = object
        self.surfaceCoordinates = surfaceCoordinates
    }
	func scatter() -> (attenuation: Color, Ray?) {
		return object.material.scatter(hitRecord: self)
	}
}

class Hittable {
	let material: Material
	init(_ m: Material) {
		self.material = m
	}
	func hit(ray: Ray, time: ClosedRange<Double>) -> HitRecord? {
		fatalError("hitting must be overriden for each hittable")
	}
}
