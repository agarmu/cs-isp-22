//
//  rng.swift
//  
//
//  Created by Mukul Agarwal on 4/13/22.
//

import Foundation

class SeededRng: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) {
        state = seed
    }

    // xorshift PRNG
    func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 17
        state ^= state << 5
        return state
    }
}
