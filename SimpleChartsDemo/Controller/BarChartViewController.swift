//
//  BarChartViewController.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 28.05.21.
//

import SimpleCharts
import UIKit

class BarChartViewController: UIViewController {
    @IBOutlet var barChartViewLarge: BarChartView!
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var slider: UISlider!

    @IBOutlet var barChartViewSmall1: BarChartView!
    @IBOutlet var barChartViewSmall2: BarChartView!
    @IBOutlet var barChartViewExtraLarge: BarChartView!

    private var defaultBarEntries: [BarEntryModel] = [
        BarEntryModel(value: 10042, color: .purpleColor, label: "17-23 Jan."),
        BarEntryModel(value: 12431, color: .purpleColor, label: "24-30 Jan."),
        BarEntryModel(value: 9132, color: .purpleColor, label: "31-06 Feb."),
        BarEntryModel(value: 11321, color: .purpleColor, label: "07-13 Feb."),
        BarEntryModel(value: 8123, color: .purpleColor, label: "14-20 Feb."),
        BarEntryModel(value: 10241, color: .purpleColor, label: "21-27 Feb."),
        BarEntryModel(value: 7123, color: .purpleColor, label: "28-06 Mar."),
        BarEntryModel(value: 5310, color: .purpleColor, label: "07-13 Mar."),

        BarEntryModel(value: 2389, color: .purpleColor, label: "14-20 Mar."),
        BarEntryModel(value: 11123, color: .purpleColor, label: "21-27 Mar."),
        BarEntryModel(value: 10420, color: .purpleColor, label: "28-03 Apr."),
        BarEntryModel(value: 4321, color: .purpleColor, label: "04-10 Apr."),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        customizableBarChart()
        smallBarCharts()
        extraLargeBarChart()
    }

    private func customizableBarChart() {
        barChartViewLarge.setBarChartOptions([
            .showYAxis(false),
            .showXAxis(false),
            .showAvgLine(false),
            .backgroundColor(.clear),
            .showScrollIndicator(false),
            .showHorizontalLines(false),
            .isScrollable(false),
            .minEntryCount(Int(slider.value)),
        ], barOptions: [
            .containerColor(.gray.withAlphaComponent(0.1)),
        ])

        barChartViewLarge.entries = [
            BarEntryModel(value: 50, color: .purpleColor, label: "1"),
            BarEntryModel(value: 20, color: .purpleColor, label: "2"),
            BarEntryModel(value: 10, color: .purpleColor, label: "3"),
            BarEntryModel(value: 22, color: .purpleColor, label: "4"),
            BarEntryModel(value: 33, color: .purpleColor, label: "5"),
            BarEntryModel(value: 54, color: .purpleColor, label: "6"),
            BarEntryModel(value: 21, color: .purpleColor, label: "7"),
            BarEntryModel(value: 12, color: .purpleColor, label: "8"),
            BarEntryModel(value: 32, color: .purpleColor, label: "9"),
            BarEntryModel(value: 12, color: .purpleColor, label: "10"),
            BarEntryModel(value: 10, color: .purpleColor, label: "11"),
            BarEntryModel(value: 5, color: .purpleColor, label: "12"),
        ]
    }

    @IBAction func segmetSelected(_ sender: UISegmentedControl) {
        let numSegments = (sender.selectedSegmentIndex + 1) * 4

        var entries = [BarEntryModel]()
        for _ in 0 ..< numSegments {
            let value = Double.random(in: 20.0 ... 100.0)
            let entry = barChartViewLarge.entries[Int.random(in: 0 ... barChartViewLarge.entries.count - 1)]
            entries.append(BarEntryModel(value: value, color: entry.color, label: entry.label))
        }

        // defaultEntries = entries
        barChartViewLarge.updateEntries(entries: entries, animationDuration: 0.4)
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        slider.value = roundedValue
        barChartViewLarge.minEntryCount = Int(slider.value)
        barChartViewLarge.updateEntries(entries: barChartViewLarge.entries, animationDuration: 0.5)
    }

    private func smallBarCharts() {
        barChartViewSmall1.setBarChartOptions([
            .useMinMaxRange(false),
            .showYAxis(false),
            .showXAxis(true),
            .showAvgLine(false),
            .backgroundColor(.clear),
            .axisTintColor(.gray),
            .xAxisSpacing(10),
            .xAxisFont(.HelveticaNeue.medium(size: 8)),
            .showScrollIndicator(false),
            .showHorizontalLines(false),
            .isScrollable(false),
            .animationDuration(0),
        ], barOptions: [
            .containerColor(.clear),
        ])

        var entries = [BarEntryModel]()
        for i in 0 ..< 4 {
            let date = Calendar.current.date(byAdding: .month, value: -1 * i, to: Date())
            entries.append(BarEntryModel(value: defaultBarEntries[i].value, color: .orangeColor.withAlphaComponent(i == 1 ? 1 : 0.4), label: date!.shortedMonth()))
        }

        barChartViewSmall1.entries = entries.reversed()

        // -----
        barChartViewSmall2.setBarChartOptions([
            .useMinMaxRange(false),
            .showYAxis(false),
            .showXAxis(true),
            .showAvgLine(false),
            .backgroundColor(.clear),
            .axisTintColor(.gray),
            .xAxisSpacing(10),
            .xAxisFont(.HelveticaNeue.medium(size: 8)),
            .showScrollIndicator(false),
            .showHorizontalLines(false),
            .isScrollable(false),
            .animationDuration(0),
            .minSpacing(8),
            .minEntryCount(7),
        ], barOptions: [
            .containerColor(.gray.withAlphaComponent(0.4)),
        ])

        let weekdays = ["M", "T", "W", "T", "F", "S", "S"]
        entries = weekdays.compactMap { weekday in
            BarEntryModel(value: Double.random(in: 0 ... 5), color: .orangeColor, label: weekday)
        }

        barChartViewSmall2.entries = entries
    }

    private func extraLargeBarChart() {
        barChartViewExtraLarge.setBarChartOptions([
            .showYAxis(true),
            .showXAxis(true),
            .showAvgLine(true),
            .xAxisFont(.HelveticaNeue.medium(size: 10)),
            .yAxisFont(.HelveticaNeue.bold(size: 12)),
            .axisTintColor(.gray),
            .avgTintColor(.purpleColor.withAlphaComponent(0.5)),
            .backgroundColor(.clear),
            .showScrollIndicator(false),
            .isScrollable(true),
            .minSpacing(12),
        ], barOptions: [
            .minBarWidth(25),
            .containerColor(.clear),
        ])

        barChartViewExtraLarge.yAxisFormatter = { (value: Double) in
            getShortedString(num: value)
        }

        barChartViewExtraLarge.entries = defaultBarEntries

        let _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [self] _ in
            var entries = [BarEntryModel]()
            for i in 0 ..< self.defaultBarEntries.count {
                let value = Double.random(in: 10000 ... 20000)
                let entry = self.defaultBarEntries[i]
                entries.append(BarEntryModel(value: value, color: entry.color, label: entry.label))
            }

            self.barChartViewExtraLarge.updateEntries(entries: entries, animationDuration: 0.5)
        }
    }
}
