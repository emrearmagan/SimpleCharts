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
        barChartViewSmall.titleView = TitleView()
        barChartViewSmall.titleView?.text = "Small"
        barChartViewSmall.titleView?.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
        barChartViewSmall.backgroundColor = .white
        barChartViewSmall.layer.cornerRadius = 10
        barChartViewSmall.entries = defaultEntries
        /*
        barChartViewLong.backgroundColor = .white
        //barChartViewLong.showLegendary = false
        barChartViewLong.layer.cornerRadius = 10
        barChartViewLong.entries = defaultEntries
        */
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            var entries = [BarEntryModel]()
            for i in 0..<self.defaultEntries.count {
                let value = Double.random(in: 20.0...100.0)
                let entry = self.defaultEntries[i]
                entries.append(BarEntryModel(value: value, color: entry.color, label: entry.label))
            }
            
            self.barChartViewSmall.updateEntries(entries: entries, animationDuration: 0.5)
        }
         
        //barChartView.titleView = TitleView(text: "Large", font: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!)
        let _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [self] timer in
            count += 1
            if count == 1 {
            barChartView.titleView = TitleView(text: "Large", font: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!)
            }
            if count == 2 {
                barChartView.titleView = nil
            }
            
            //barChartView.titleView?.font = UIFont(name: "HelveticaNeue-Bold", size: (barChartView.titleView?.font.pointSize)! + CGFloat(count))!
            
            /*
            if count % 2 == 0 {
                barChartView.titleView = TitleView(text: "Large", font: UIFont(name: "HelveticaNeue-Bold", size: 20.0)!)
            }else {
                barChartView.titleView = nil
            }*/
        }
    }
    
    var count = 0
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
