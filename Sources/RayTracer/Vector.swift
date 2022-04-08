import Foundation
import SwiftImage

typealias Point = Vector

struct Vector {
    let x: Double
    let y: Double
    let z: Double
    init(_ a: Double, _ b: Double, _ c: Double) {
        x = a
        y = b
        z = c
    }
}

extension Vector: ExpressibleByArrayLiteral {
    init(arrayLiteral: Double...) {
        assert(arrayLiteral.count == 3, "Must initialize vector with 3 values.")
        self.x = arrayLiteral[0]
        self.y = arrayLiteral[1]
        self.z = arrayLiteral[2]
    }
}

extension Vector: CustomStringConvertible {
    var description: String {
        return "‹\(x), \(y), \(z)›"
    }
    var magnitudeSquared: Double {
        self • self
    }
    var magnitude: Double {
        magnitudeSquared.squareRoot()
    }
    var invmag: Double {
        invSqrt(magnitudeSquared)
    }
}


precedencegroup DotProductPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}
precedencegroup RayCreationPrecedence {
    lowerThan: AdditionPrecedence
    higherThan: DotProductPrecedence
    associativity: left
}

infix operator •: DotProductPrecedence // dot product
infix operator ×: MultiplicationPrecedence // cross product
infix operator ⊙: MultiplicationPrecedence // hadamard product
infix operator »: RayCreationPrecedence
extension Vector {
    static func + (l: Vector, r: Vector) -> Vector {
        return [l.x + r.x, l.y + r.y, l.z + r.z]
    }
    static func + (l: Vector, r: Double) -> Vector {
        return [l.x + r, l.y + r, l.z + r]
    }
    static func + (l: Double, r: Vector) -> Vector {
        return r + l
    }
    static func += (l: inout Vector, r: Vector) {
        l = l + r
    }
    static func += (l: inout Vector, r: Double) {
        l = l + r
    }
    static prefix func - (v: Vector) -> Vector {
        return [-v.x, -v.y, -v.z]
    }
    static func - (l: Vector, r: Vector) -> Vector {
        return [l.x - r.x, l.y - r.y, l.z - r.z]
    }
    static func - (l: Vector, r: Double) -> Vector {
        return l + (-r)
    }
    static func -= (l: inout Vector, r: Vector) {
        l = l - r
    }
    static func -= (l: inout Vector, r: Double) {
        l = l - r
    }

    // scalar
    static func * (l: Vector, r: Double) -> Vector {
        return [l.x * r, l.y * r, l.z * r]
    }
    static func * (l: Double, r: Vector) -> Vector {
        return r * l
    }
    static func *= (l: inout Vector, r: Double) {
        l = l * r
    }
    static func / (l: Vector, r: Double) -> Vector {
        return l * (1/r)
    }
    static func /= (l: inout Vector, r: Double) {
        l = l / r
    }

    // dot
    static func • (l: Vector, r: Vector) -> Double {
        return l.x * r.x + l.y * r.y + l.z * r.z
    }
    // cross
    static func × (l: Vector, r: Vector) -> Vector {
        return [
          l.y * r.z - l.z * r.y,
          l.z * r.x - l.x * r.z,
          l.x * r.y - l.y * r.x
        ]
    }
    // hadamard
    static func ⊙ (l: Vector, r: Vector) -> Vector {
        return [l.x * r.x, l.y * r.y, l.z * r.z]
    }
    // create ray
    static func » (l: Vector, r: Vector) -> Ray {
        Ray(from: l, to: r)
    }
    func color() -> RGBA<UInt8> {
        let r = UInt8(255.999 * x)
        let g = UInt8(255.999 * y)
        let b = UInt8(255.99 * z)
        return RGBA(red: r, green: g, blue: b, alpha: 255)
    }
    func normalized() -> Self {
        self / magnitude
    }
}

extension Vector: Equatable {
    static func == (l: Vector, r: Vector) -> Bool {
        return l.x == r.x && l.y == r.y && l.z == r.z
    }
}
