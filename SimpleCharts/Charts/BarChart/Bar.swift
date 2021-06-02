//
//  Bar.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 30.05.21.
//

import Foundation

// Represents a Bar in the BarChart. Each Bar consists of a layer and data.
public struct Bar: Hashable {
    public internal(set) var layer: BarLayer
    public internal(set) var data: BarLayerData
    
    public init(layer: BarLayer, data: BarLayerData) {
        self.layer = layer
        self.data = data
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(data.id)
    }
    
    public static func == (lhs: Bar, rhs: Bar) -> Bool {
        return lhs.data.id == rhs.data.id
    }
}


