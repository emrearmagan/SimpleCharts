//
//  GroupChartViewController.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit
import SimpleCharts

class GroupChartViewController: UIViewController {
    
    @IBOutlet weak var groupedChartView: GroupedBarChartView!
    private var groupedData = [entries.FacebookEntry, entries.InstagramEntry, entries.DribbbleEntry, entries.GithubEntry, entries.TwitterEntry, entries.Spotify]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var groupedEntries = [GroupedEntryModel]()
        for entry in groupedData {
            if let label = entry.first?.label {
                groupedEntries.append(GroupedEntryModel(entries: entry, label: label))
            }
        }

        groupedChartView.setGroupBarChartOptions([
            .xAxisFont(.HelveticaNeue.medium(size: 10)),
            .yAxisFont(.HelveticaNeue.bold(size: 10)),
            .showXAxis(true),
            .showYAxis(true),
            .showAvgLine(false),
            .backgroundColor(.clear),
            .minSpacing(4),
            .showScrollIndicator(false),
            .scrollViewWidthInsets(21),
            .horizontalLineTintColor(.lightGray.withAlphaComponent(0.5)),
            .axisTintColor(.gray),
            .insets(UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 0)),
        ],groupBarOptions: [
            .barchartOptions([
                .minBarWidth(36),
                .cornerRounding(5),
                .containerColor(.clear)
            ]),
            .groupSpacing(30)
        ])
        
        groupedChartView.yAxisFormatter = { (value: Double) in
            return getShortedString(num: value)
        }
        
        groupedChartView.updateEntries(entries: groupedEntries, animationDuration: 0.5)
        updateChart()
    }
    
    private func updateChart() {
        DispatchQueue.main.async {
            let _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [self] timer in
                var entries = [GroupedEntryModel]()
                for entry in groupedData {
                    
                    var updateEntries = [BarEntryModel]()
                    for e in entry {
                        let entry = BarEntryModel(value: Double.random(in: max(0, e.value - 2000)...e.value + 2000), color: e.color, label: e.label)
                        updateEntries.append(entry)
                    }
                    if let first = updateEntries.first {
                        entries.append(GroupedEntryModel(entries: updateEntries, label: first.label))
                    }
                }
                
                self.groupedChartView.updateEntries(entries: entries, animationDuration: 0.5)
            }
        }

    }
}

struct entries {
    static let FacebookEntry: [BarEntryModel] = [
        BarEntryModel(value: 5214, color: UIColor.init(red: 24/255, green: 119/255, blue: 242/255, alpha: 1), label: "Facebook"),
        BarEntryModel(value: 4541, color: UIColor.init(red: 24/255, green: 119/255, blue: 242/255, alpha: 1), label: "Facebook"),
    ]
    
    static let InstagramEntry: [BarEntryModel] = [
        BarEntryModel(value: 12051, color: UIColor.init(red: 236/255, green: 96/255, blue: 86/255, alpha: 1), label: "Instagram"),
        BarEntryModel(value: 15413, color: UIColor.init(red: 236/255, green: 96/255, blue: 86/255, alpha: 1), label: "Instagram"),
    ]
    
    static let DribbbleEntry: [BarEntryModel] = [
        BarEntryModel(value: 2032, color: UIColor.init(red: 246/255, green: 117/255, blue: 167/255, alpha: 1), label: "Dribbble"),
        BarEntryModel(value: 1245, color: UIColor.init(red: 246/255, green: 117/255, blue: 167/255, alpha: 1), label: "Dribbble"),
    ]
    
    static let GithubEntry: [BarEntryModel] = [
        BarEntryModel(value: 1034, color: UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), label: "Github"),
    ]
    
    static let TwitterEntry: [BarEntryModel] = [
        BarEntryModel(value: 10243, color: UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), label: "Twitter"),
        BarEntryModel(value: 2135, color: UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), label: "Twitter"),
    ]
    
    
    static let Spotify: [BarEntryModel] = [
        BarEntryModel(value: 600, color: UIColor.init(red: 29/255, green: 185/255, blue: 84/255, alpha: 1), label: "Spotify"),
    ]
}
