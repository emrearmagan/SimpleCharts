//
//  BarChartViewController.swift
//  SimpleChartsDemo
//
//  Created by Emre Armagan on 28.05.21.
//

import UIKit
import SimpleCharts

class BarChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var barChartViewSmall: BarChartView!
    @IBOutlet weak var barChartViewLong: BarChartView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    private var defaultEntries: [BarEntryModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultEntries = [
            BarEntryModel(value: 5, color: UIColor.init(red: 234/255, green: 76/255, blue: 137/255, alpha: 1), label: "Dribbble"),
            BarEntryModel(value: 10, color: UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1), label: "Github"),
            BarEntryModel(value: 5, color: UIColor.init(red: 24/255, green: 119/255, blue: 242/255, alpha: 1), label: "Facebook"),
            BarEntryModel(value: 20, color: UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), label: "Twitter"),
            BarEntryModel(value: 8, color: UIColor.init(red: 29/255, green: 185/255, blue: 84/255, alpha: 1), label: "Spotify"),
            BarEntryModel(value: 15, color: UIColor.init(red: 53/255, green: 70/255, blue: 92/255, alpha: 1), label: "Tumblr")
        ]
        
        barChartView.backgroundColor = .white
        barChartView.layer.cornerRadius = 10
        barChartView.entries = defaultEntries
        
        //barChartViewSmall.showLegendary = false
        barChartViewSmall.backgroundColor = .white
        barChartViewSmall.showLegendary = false
        barChartViewSmall.layer.cornerRadius = 10
        barChartViewSmall.entries = defaultEntries
        
        barChartViewLong.backgroundColor = .white
        barChartViewLong.showLegendary = false
        barChartViewLong.layer.cornerRadius = 10
        barChartViewLong.entries = defaultEntries
        
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            var entries = [BarEntryModel]()
            for i in 0..<self.defaultEntries.count {
                let value = Double.random(in: 20.0...100.0)
                let entry = self.defaultEntries[i]
                entries.append(BarEntryModel(value: value, color: entry.color, label: entry.label))
            }
            
            entries.append(self.defaultEntries[Int.random(in: 0...5)])
            self.barChartViewSmall.updateEntries(entries: entries, animationDuration: 0.5)
        }
    }
    

    @IBAction func segmetSelected(_ sender: UISegmentedControl) {
        let numSegments = (sender.selectedSegmentIndex + 1) * 4
        
        var entries = [BarEntryModel]()
        
        for _ in 0..<numSegments {
            let value = Double.random(in: 20.0...100.0)
            let entry = defaultEntries[Int.random(in: 0...defaultEntries.count - 1)]
            entries.append(BarEntryModel(value: value, color: entry.color, label: entry.label))
        }
        
        barChartView.entries = entries
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
