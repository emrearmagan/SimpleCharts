//
//  Double.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

infix operator &/

extension Double {
    // overflow operator
    public static func &/(lhs: Double, rhs: Double) -> Double {
        if rhs == 0 {
            return 0
        }
        return lhs/rhs
    }
    
}
