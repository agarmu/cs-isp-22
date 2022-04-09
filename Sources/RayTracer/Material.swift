//
//  Material.swift
//  
//
//  Created by Mukul Agarwal on 4/8/22.
//

import Foundation

class Material {
	func scatter(hitRecord: HitRecord) -> (attenuation: Color, Ray?) {
        fatalError("scattering of rays must be overriden for each material")
    }
}
