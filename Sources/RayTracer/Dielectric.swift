//
//  Dielectric.swift
//  
//
//  Created by Mukul Agarwal on 4/9/22.
//

import Foundation

class Dielectric: Material {
    let indexOfRefraction: Double
    init(indexOfRefraction iR: Double) {
        indexOfRefraction = iR.clamp(to: 0.001...1000)
    }
    static private let attenuation = Color(1.0, 1.0, 1.0)
    override func scatter(hitRecord: HitRecord) -> (attenuation: Color, Ray?) {
        let ir = hitRecord.frontFace ? (1.0/indexOfRefraction) : indexOfRefraction
        let unitDir = hitRecord.ray.direction.normalized()
        if let refracted = unitDir.refract(normalTo: hitRecord.normal, refractionRatio: ir) {
            // check for reflectance
            let cos = min(-unitDir • hitRecord.normal, 1.0)
            if Dielectric.reflectance(cos: cos, refractionRatio: ir) < Double.random(in: 0...1) {
                // can refract
                return (Dielectric.attenuation, hitRecord.p » refracted)
            }
        }
        // default to total internal reflection
        let reflected = unitDir.reflect(normalTo: hitRecord.normal)
        return (Dielectric.attenuation, hitRecord.p » reflected)
    }
    static private func reflectance(cos: Double, refractionRatio: Double) -> Double {
        // Schlick's Approximation
        let r = pow((1-refractionRatio)/(1+refractionRatio), 2.0)
        return r * (1-r)*pow((1-cos), 5)
    }
}
