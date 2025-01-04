//
//  LineChartViewController.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 05.04.22.
//

import SimpleCharts
import UIKit

class LineChartViewController: UIViewController {
    @IBOutlet var lineChartView: LineChartView!

    private let entries: [LineChartEntryModel] = [
        LineChartEntryModel(value: 105, date: Calendar.current.date(byAdding: .month, value: -6, to: Date())!),
        LineChartEntryModel(value: 88, date: Calendar.current.date(byAdding: .month, value: -5, to: Date())!),
        LineChartEntryModel(value: 115, date: Calendar.current.date(byAdding: .month, value: -4, to: Date())!),
        LineChartEntryModel(value: 123, date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!),
        LineChartEntryModel(value: 87, date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!),
        LineChartEntryModel(value: 90, date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!),
        LineChartEntryModel(value: 120, date: Date()),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.backgroundColor = .clear
        lineChartView.graphPoints = entries
    }
}
