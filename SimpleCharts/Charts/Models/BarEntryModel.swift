//
//  BarEntry.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 29.05.21.
//

import Foundation
import UIKit

public class BaseEntryModel {
    public let color: UIColor
    public let label: String
    
    public init(color: UIColor, label: String) {
        self.color = color
        self.label = label
    }
}

public class BarEntryModel: BaseEntryModel, Comparable {
    public var value: Double
    
    public static func <(lhs: BarEntryModel, rhs: BarEntryModel) -> Bool {
        return lhs.value < rhs.value
    }
    public static func ==(lhs: BarEntryModel, rhs: BarEntryModel) -> Bool {
        return lhs.value == rhs.value
    }
    
    public init(value: Double, color: UIColor, label: String) {
        self.value = value
        super.init(color: color, label: label)
    }
}
