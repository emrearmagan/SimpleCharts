//
//  LineChartEntryModel.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

//TODO: Convert to BaseEntryModel
public class LineChartEntryModel: Comparable, Hashable {
    let value: Int
    let date: Date
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
    
    public static func <(lhs: LineChartEntryModel, rhs: LineChartEntryModel) -> Bool {
        return lhs.date < rhs.date
    }
    public static func ==(lhs: LineChartEntryModel, rhs: LineChartEntryModel) -> Bool {
        return Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
    }
    
    public init(value: Int, date: Date) {
        self.value = value
        self.date = date
    }
}
