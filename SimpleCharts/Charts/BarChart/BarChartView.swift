//
//  BarChartView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

public class BarChartView: BaseBarChartView {
    // MARK: Properties

    /// Array of bar entries. Each entry contains information about its values, color and label
    public var entries: [BarEntryModel] = [] {
        didSet {
            layoutIfNeeded()

            baseEntries = entries

            container.sublayers?.forEach { $0.removeFromSuperlayer() }
            bars = generateBars(entries: entries)
        }
    }

    /// Delegate of  BarChartView
    weak var delegate: BarChartDelegate?

    /// Contains all Bars from the BarLayer
    fileprivate(set) var bars: [Bar] = [] {
        didSet {
            for (index, bar) in bars.enumerated() {
                container.addSublayer(bar.container)
                bar.container.present(animated: animated, oldLayer: updatingEntries ? oldValue[safe: index]?.container : nil)
            }
        }
    }

    // MARK: Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: Functions

    override public func updateEntries(entries: [BaseEntryModel], animationDuration: Double) {
        guard let entries = entries as? [BarEntryModel] else {
            return
        }
        self.animationDuration = animationDuration

        updatingEntries = true
        self.entries = entries
        updatingEntries = false
    }

    override func notifyConstraintChanges() {
        for (index, bar) in bars.enumerated() {
            let xPos: CGFloat = calculateXPos(for: index)
            let yPos: CGFloat = translateHeightValueToYPosition(value: bar.data.model?.value ?? container.bounds.size.height)

            let containerBound = CGRect(x: xPos, y: 0, width: barWidth, height: container.bounds.size.height)
            bar.container.frame = containerBound
            bar.container.setBarLayerHeight(to: yPos, direction: .bottom)
        }
        // updateEntries(entries: entries, animationDuration: 0.5)
    }

    private func generateBars(entries: [BarEntryModel]) -> [Bar] {
        var bars: [Bar] = []

        for index in 0 ..< _maxEntries {
            let entry = entries[safe: index]
            let bar = generateBar(entry: entry, index: index)
            bars.append(bar)
        }

        guard let minBars = minEntryCount else {
            return bars
        }

        if _maxEntries < minBars {
            for i in 0 ..< minBars - _maxEntries {
                let bar = generateBar(entry: nil, index: i + numberOfEntries)
                bars.append(bar)
            }
        }
        return bars
    }

    private func generateBar(entry: BarEntryModel?, index: Int) -> Bar {
        let data = BarContainerData(model: entry, id: index)

        let bar = Bar(container: BarContainer(width: barWidth, color: entry?.color ?? .clear, animationDuration: animationDuration, animationDelay: animationDelay, cornerRounding: cornerRounding, containerColor: containerColor), data: data)

        let xPos: CGFloat = calculateXPos(for: index)
        let yPos: CGFloat = translateHeightValueToYPosition(value: entry?.value ?? container.bounds.size.height)

        let containerBound = CGRect(x: xPos, y: 0, width: barWidth, height: container.bounds.size.height)

        bar.container.frame = containerBound
        bar.container.setBarLayerHeight(to: yPos, direction: .bottom)
        bar.container.containerDelegate = self
        bar.container.barEntry = data

        return bar
    }
}

// MARK: Touch

extension BarChartView {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard markSelected else { return }

        if let touch = touches.first, let touchedLayer = layerFor(touch) as? BarContainer {
            // print(touchedLayer.hashValue)
            for bar in bars {
                let selected = bar.container.selected
                bar.container.selected = bar.container.hashValue == touchedLayer.hashValue ? !selected : false
            }
        }
    }

    private func layerFor(_ touch: UITouch) -> Any? {
        let view = self
        let touchLocation = touch.location(in: view)
        let locationInView = view.convert(touchLocation, to: nil)

        let hitPresentationLayer = view.layer.presentation()?.hitTest(locationInView)

        return hitPresentationLayer?.model()
    }
}

// MARK: BarLayerDelegate

extension BarChartView: BarContainerDelegate {
    public func animationDidStart(bar: Bar) {
        delegate?.animationDidStartFor(bar: bar)
    }

    public func animationDidStop(bar: Bar) {
        delegate?.animationDidStopFor(bar: bar)
    }

    public func didSelectLayer(bar: Bar) {
        delegate?.didSelect(selectedBar: bar)
    }
}
