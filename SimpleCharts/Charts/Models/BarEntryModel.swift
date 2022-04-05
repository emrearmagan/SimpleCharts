//
//  SYBarEntryModel.swift
//  socially
//
//  Created by Emre Armagan on 07.09.21.
//

import UIKit


public class BarEntryModel: BaseEntryModel {
    public let color: UIColor
    
    public init(value: Double, color: UIColor, label: String) {
        self.color = color
        super.init(value: value, label: label)
    }
}
