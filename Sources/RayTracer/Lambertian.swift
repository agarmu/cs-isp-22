//
//  File.swift
//  
//
//  Created by Mukul Agarwal on 4/8/22.
//

import Foundation

class Lambertian: Material {
    let albedo: Texture
    init(_ albedo: Color) {
        self.albedo = SolidTexture(color: albedo)
    }
    init(_ albedo: Texture) {
        self.albedo = albedo
    }
    override func scatter(hitRecord: HitRecord) -> (attenuation: Color, Ray?) {
        var scatterDirection = hitRecord.normal + Vector.randomOnUnitSphere()
        if scatterDirection.nearZero() {
            scatterDirection = hitRecord.normal
        }
        let scattered = hitRecord.p » scatterDirection
        return (attenuation: albedo.value(hitRecord), Double.random(in:0...1) < 0.5 ? scattered : nil)
    }
}
