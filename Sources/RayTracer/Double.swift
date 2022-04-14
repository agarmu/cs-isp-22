//
//  File.swift
//  
//
//  Created by Mukul Agarwal on 4/8/22.
//

import Foundation

extension Double {
    func clamp(to range: ClosedRange<Double>) -> Self {
        return max(min(range.upperBound, self), range.lowerBound)
    }
    func declamp(from range: ClosedRange<Double>) -> Self {
        guard range.contains(self) else {
            return self
        }
        // check against midpoint
        if self <= (range.lowerBound + range.upperBound) / 2 {
            return range.lowerBound
        } else {
            return range.upperBound
        }
    }
}
