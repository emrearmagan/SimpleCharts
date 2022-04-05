//
//  RangeBar.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

// Represents a Bar in the BarChart. Each Bar consists of a layer and data.
public struct RangeBar {
    public internal(set) var groupId: Int
    public internal(set) var isMax: Bool
    public internal(set) var initialValue: Double
    public internal(set) var bar: Bar
    
    public init(id: Int, isMax: Bool, initalValue: Double, bar: Bar) {
        self.groupId = id
        self.isMax = isMax
        self.initialValue = initalValue
        self.bar = bar
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(groupId)
    }
    
    public static func == (lhs: RangeBar, rhs: RangeBar) -> Bool {
        return lhs.groupId == rhs.groupId && lhs.bar.data.id == rhs.bar.data.id
    }
}
