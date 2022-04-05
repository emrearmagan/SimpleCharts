//
//  SYBaseEntryModel.swift
//  socially
//
//  Created by Emre Armagan on 07.09.21.
//

import UIKit

public class BaseEntryModel: Comparable {
    public let label: String
    public var value: Double
    
    
    public static func <(lhs: BaseEntryModel, rhs: BaseEntryModel) -> Bool {
        return lhs.value < rhs.value
    }
    public static func ==(lhs: BaseEntryModel, rhs: BaseEntryModel) -> Bool {
        return lhs.value == rhs.value
    }
 
    public init(value: Double, label: String) {
        self.value = value
        self.label = label
    }
}

