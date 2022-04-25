//
//  Metal.swift
//  
//
//  Created by Mukul Agarwal on 4/8/22.
//

import Foundation

class Metal: Material {
    let albedo: Texture
    let fuzz: Double
    init(_ albedo: Color, fuzz: Double) {
        self.albedo = SolidTexture(color: albedo)
        self.fuzz = fuzz.clamp(to: 0...1)
    }
    init(_ albedo: Texture, fuzz: Double) {
        self.albedo = albedo
        self.fuzz = fuzz.clamp(to: 0...1)
    }
    override func scatter(hitRecord: HitRecord) -> (attenuation: Color, Ray?) {
        let reflected = hitRecord.ray.direction.normalized().reflect(normalTo: hitRecord.normal) + fuzz * Vector.randomInUnitSphere()
        let reflects = (reflected • hitRecord.normal) > 0
        return (attenuation: albedo.value(hitRecord), reflects ? (hitRecord.p » reflected) : nil)
    }
}
