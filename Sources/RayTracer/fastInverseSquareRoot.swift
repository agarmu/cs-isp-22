// Fast Inverse Square Root algorithm
// See: http://en.wikipedia.org/wiki/Fast_inverse_square_root

let magicNumber: UInt64 = 0x5FE6EB50C7B537A9

func invSqrt(_ k: Double) -> Double {
    // bit-pattern manipulation
    var i = k.bitPattern
    i = magicNumber - (i >> 1)
    var x = Double(bitPattern: i)
    
    // two iterations of Newton's Method
    x = x * (1.5 - (k/2 * x * x))
    x = x * (1.5 - (k/2 * x * x))
    return x
}
