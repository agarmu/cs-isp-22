import Foundation

struct Vector {
    let x: Double
    let y: Double
    let z: Double
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
        return "(\(x), \(y), \(z))"
    }
}


precedencegroup DotProductPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}

infix operator •: DotProductPrecedence // dot product
infix operator ×: MultiplicationPrecedence // cross product
extension Vector {
    static func + (l: Vector, r: Vector) -> Vector {
        return [l.x + r.x, l.y + r.y, l.z + r.z]
    }
    static func += (l: inout Vector, r: Vector) {
        l = l + r
    }
    static prefix func - (v: Vector) -> Vector {
        return [-v.x, -v.y, -v.z]
    }
    static func - (l: Vector, r: Vector) -> Vector {
        return [l.x - r.x, l.y - r.y, l.z - r.z]
    }
    static func -= (l: inout Vector, r: Vector) {
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
        
}

extension Vector: Equatable {
    static func == (l: Vector, r: Vector) -> Bool {
        return l.x == r.x && l.y == r.y && l.z == r.z
    }
}
