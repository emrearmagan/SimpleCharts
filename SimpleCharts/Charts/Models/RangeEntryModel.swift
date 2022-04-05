//
//  RangeEntryModel.swift
//  socially
//
//  Created by Emre Armagan on 08.11.21.
//

import UIKit

public class RangeBarEntryModel: BaseEntryModel {
    public let color: UIColor
    public let min: Double
    public let max: Double
    
    public init(value: Double, min: Double, max: Double, color: UIColor, label: String) {
        self.color = color
        self.min = min
        self.max = max
        super.init(value: value, label: label)
    }
}
