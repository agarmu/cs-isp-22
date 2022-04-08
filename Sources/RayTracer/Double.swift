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
}
