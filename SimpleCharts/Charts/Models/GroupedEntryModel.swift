//
//  SYGroupedEntryModel.swift
//  socially
//
//  Created by Emre Armagan on 05.11.21.
//

import UIKit

public class GroupedEntryModel: BaseEntryModel {
    public let entries: [BarEntryModel]
    
    public init(entries: [BarEntryModel], label: String) {
        let avg = entries.enumerated().reduce(0.0) {$0 + ($1.element.value - $0) / Double($1.0 + 1)}
        self.entries = entries
        super.init(value: avg, label: label)
    }
    
}

