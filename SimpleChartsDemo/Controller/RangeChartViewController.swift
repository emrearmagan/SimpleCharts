//
//  RangeChartViewController.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit
import SimpleCharts

class RangeChartViewController: UIViewController {

    @IBOutlet weak var chartViewContainer: UIView!
    @IBOutlet weak var legend: UIStackView!
    
    private var chartView: BaseChartView?
    
    private let rangeEntries: [RangeBarEntryModel] = [
        RangeBarEntryModel(value: 20, min: 10, max: 22, color: .orangeColor, label: "Sep."),
        RangeBarEntryModel(value: 15, min: 8, max: 30, color: .orangeColor, label: "Oct."),
        RangeBarEntryModel(value: 23, min: 15, max: 30, color: .orangeColor, label: "Nov."),
        RangeBarEntryModel(value: 10, min: 5, max: 20, color: .orangeColor, label: "Dec."),
        RangeBarEntryModel(value: 17, min: 12, max: 22, color: .orangeColor, label: "Jan,"),
        RangeBarEntryModel(value: 9, min: 3, max: 30, color: .orangeColor, label: "Feb."),
        RangeBarEntryModel(value: 23, min: 15, max: 27, color: .orangeColor, label: "Mar."),
        RangeBarEntryModel(value: 20, min: 13, max: 30, color: .orangeColor, label: "Apr.")
    ]
    
    private var barEntries: [BarEntryModel] = [
        BarEntryModel(value: 8123, color: .orangeColor, label: "14-20 Feb."),
        BarEntryModel(value: 10241, color: .orangeColor, label: "21-27 Feb."),
        BarEntryModel(value: 7123, color: .orangeColor, label: "28-06 Mar."),
        BarEntryModel(value: 5310, color: .orangeColor, label: "07-13 Mar."),
        BarEntryModel(value: 2389, color: .orangeColor, label: "14-20 Mar."),
        BarEntryModel(value: 11123, color: .orangeColor, label: "21-27 Mar."),
        BarEntryModel(value: 10420, color: .orangeColor, label: "28-03 Apr."),
        BarEntryModel(value: 4321, color: .orangeColor, label: "04-10 Apr.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartViewContainer.backgroundColor = .clear
        setupRangeChart()
    }
    
    private func setupBarChart() {
        legend.isHidden = true
        self.chartView = BarChartView()
        setConstraints()
        chartOptions()
        guard let chartView = self.chartView as? BarChartView else { return }
        chartView.showAvgLine = true
        chartView.updateEntries(entries: barEntries, animationDuration: 0.5)
    }
    
    private func setupRangeChart() {
        legend.isHidden = false
        self.chartView = RangeBarChartView()
        setConstraints()
        chartOptions()
        guard let chartView = self.chartView as? RangeBarChartView else { return }
        chartView.showAvgLine = false
        
        chartView.updateEntries(entries: rangeEntries, animationDuration: 0.5)
    }
    
    @IBAction func segmetChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setupBarChart()
            return
        }
        
        setupRangeChart()
    }
}


extension RangeChartViewController {
    private func chartOptions() {
        guard let chartView = self.chartView as? BaseBarChartView else { return }
        
        chartView.setBarChartOptions([
            .maxVisibleCount(8),
            .minEntryCount(8),
            .xAxisFont(UIFont.HelveticaNeue.medium(size: 10)),
            .yAxisFont(UIFont.HelveticaNeue.bold(size: 12)),
            .axisTintColor(.gray),
            .showYAxis(false),
            .showXAxis(true),
            .avgTintColor(.orangeColor.withAlphaComponent(0.7)),
            .backgroundColor(.clear),
            .showScrollIndicator(false),
            .showHorizontalLines(false),
            .isScrollable(false),
            .minSpacing(18),
        ], barOptions: [
            .cornerRounding(5),
        ])
    }
    private func setConstraints() {
        chartViewContainer.subviews.forEach({$0.removeFromSuperview()})
        
        guard let chartView = chartView else {
            return
        }

        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartViewContainer.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: chartViewContainer.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: chartViewContainer.bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: chartViewContainer.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: chartViewContainer.trailingAnchor)
        ])
    }
}
