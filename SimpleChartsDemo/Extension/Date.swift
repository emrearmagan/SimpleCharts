//
//  Date.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

extension Date {
    func shortedMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: self)
    }
    
    func shortedWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: self)
    }
}
