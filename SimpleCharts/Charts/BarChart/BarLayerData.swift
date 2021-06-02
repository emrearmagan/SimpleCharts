//
//  BarLayerData.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 30.05.21.
//

import Foundation

public class BarLayerData {
    public let model: BarEntryModel
    public internal(set) var id: Int
    
    public init(model: BarEntryModel, id: Int) {
        self.model = model
        self.id = id
    }
}
