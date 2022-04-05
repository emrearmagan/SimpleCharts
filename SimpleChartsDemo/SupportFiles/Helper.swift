//
//  Helper.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

func getShortedString(num: Double) -> String {
    let absNum = abs(num)
    
    let thousandNum = absNum/1000
    let millionNum = absNum/1000000
    
    if absNum >= 10000 && absNum < 1000000 {
        if(floor(thousandNum) == thousandNum){
            return getShortedString(isNegative: num < 0, shortedString: "\(Int(thousandNum))k")
        }
        let rounded = roundToPlaces(thousandNum, 1)
        if (floor(thousandNum) == rounded) {
            return getShortedString(isNegative: num < 0, shortedString: "\(Int(thousandNum))k")
        }
        return getShortedString(isNegative: num < 0, shortedString: "\(rounded)k")
    } else if absNum >= 1000000 {
        if(floor(millionNum) == millionNum){
            return getShortedString(isNegative: num < 0, shortedString: "\(Int(millionNum))M")
        }
        
        let rounded = roundToPlaces(millionNum, 1)
        if (floor(millionNum) == rounded) {
            return getShortedString(isNegative: num < 0, shortedString: "\(Int(millionNum))M")
        }
        
        return getShortedString(isNegative: num < 0, shortedString: "\(rounded)M")
    }
    else{
        if (floor(absNum) == absNum) {
            return("\(Int(num))")
        }
        return ("\(num)")
    }
}

private func getShortedString(isNegative: Bool, shortedString: String) -> String {
    return("\(isNegative ? "-" : "")\(shortedString)")
}

// Rounds the double to decimal places value
func roundToPlaces(_ num: Double, _ places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return floor(num * divisor) / divisor
}
