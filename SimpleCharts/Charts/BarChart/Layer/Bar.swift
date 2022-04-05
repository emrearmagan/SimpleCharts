//
//  Bar.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

// Represents a Bar in the BarChart. Each Bar consists of a layer and data.
public struct Bar: Hashable {
    public internal(set) var container: BarContainer
    public internal(set) var data: BarContainerData
    
    public init(container: BarContainer, data: BarContainerData) {
        self.container = container
        self.data = data
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(data.id)
    }
    
    public static func == (lhs: Bar, rhs: Bar) -> Bool {
        return lhs.data.id == rhs.data.id
    }
}
