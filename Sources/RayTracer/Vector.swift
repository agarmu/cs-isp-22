import Foundation

typealias Point = Vector
typealias Color = Vector

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
    func ppm() -> String {
        let r = UInt((65536 * x).clamp(to: 0...0.65535))
        let g = UInt((65536 * y).clamp(to: 0...0.65535))
        let b = UInt((65536 * z).clamp(to: 0...0.65535))
        return "\(r) \(g) \(b)"
    }
    func normalized() -> Self {
        self / magnitude
    }
    static func random(in range: ClosedRange<Double>) -> Self {
        return [Double.random(in: range), Double.random(in: range), Double.random(in: range)]
    }
    static func random<T: RandomNumberGenerator>(in range: ClosedRange<Double>, using rng: inout T) -> Self {
        return [
            Double.random(in: range, using: &rng),
            Double.random(in: range, using: &rng),
            Double.random(in: range, using: &rng),
        ]
    }
    func gamma(_ value: Double) -> Self {
        let exponent = 1 / value
        return [pow(self.x, exponent), pow(self.y, exponent), pow(self.z, exponent)]
    }
    static func randomInUnitSphere() -> Self {
        var v: Vector
        repeat {
            v = Vector.random(in: 0...1)
        } while v.magnitudeSquared > 1
        return v
    }

    static func randomOnUnitSphere() -> Self {
        Self.randomInUnitSphere().normalized()
    }
	static func randomInUnitDisc() -> Self {
		var v: Vector
		repeat {
			v = [Double.random(in: -1...1), Double.random(in: -1...1), 0]
		} while v.magnitudeSquared > 1
		return v
	}
	func reflect(normalTo n: Vector) -> Vector {
		return self - 2*(self•n)*n
	}
	func refract(normalTo n: Vector, refractionRatio: Double) -> Vector? {
		let cosTheta = min(-self • n, 1.0)
		let sinTheta = sqrt(1.0 - pow(cosTheta, 2.0))
		if refractionRatio * sinTheta > 1.0 {
			return nil
		}
		let rOutPerp = refractionRatio * (self + cosTheta*n)
		let rOutPar = -sqrt((1.0 - rOutPerp.magnitudeSquared)) * n
		return rOutPerp + rOutPar
	}
}
extension Vector {
	static fileprivate let maxDiff = pow(10.0, -8.0)
	func nearZero() -> Bool {
		return
			(abs(x) < Vector.maxDiff) &&
			(abs(y) < Vector.maxDiff) &&
			(abs(z) < Vector.maxDiff)
	}
}
extension Vector: Equatable {
    static func == (l: Vector, r: Vector) -> Bool {
        return l.x == r.x && l.y == r.y && l.z == r.z
    }
}
