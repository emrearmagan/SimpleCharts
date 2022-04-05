//
//  as.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import Foundation

public protocol BarChartDelegate: AnyObject {
    // Called when a Bar has been selected inside the BarChartView
    func didSelect(selectedBar: Bar)
    
    // Called when the animation for a Bar has started
    func animationDidStartFor(bar: Bar)
    
    // Called when the animation for a Bar has finished/stopped
    func animationDidStopFor(bar: Bar)
}
