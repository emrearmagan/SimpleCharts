//
//  BaseChartView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 04.04.22.
//

import UIKit

public enum BaseChartViewOption {
    case animationDuration(Double)
    case animationDelay(Double)
    case maxVisibleCount(Int)
    case showAvgLine(Bool)
    case showHorizontalLines(Bool)
    case showXAxis(Bool)
    case showYAxis(Bool)
    case avgTintColor(UIColor)
    case axisTintColor(UIColor)
    case horizontalLineTintColor(UIColor)
    case xAxisFont(UIFont)
    case yAxisFont(UIFont)
    case minEntryCount(Int)
    case minSpacing(CGFloat)
    case backgroundColor(UIColor)
    case shouldAutoFormatXAxis(Bool)
    case xAxisSpacing(Double)
    case useMinMaxRange(Bool)
    case showScrollIndicator(Bool)
    case scrollViewWidthInsets(CGFloat)
    case isScrollable(Bool)
    case insets(UIEdgeInsets)
}

open class BaseChartView: UIView {
    // MARK: Properties

    /// Flag indicated whether to animate the chart
    var animated: Bool {
        return animationDuration > 0
    }

    /// Duration of the animation for every Bar/line
    open var animationDuration: Double = 0.5

    /// Delay of the animation for every Bar/Line inside the Chart
    open var animationDelay: Double = 0

    /// Flag indicated whether to show the average line
    public var showAvgLine: Bool = false

    /// Flag indicated whether to show the horizontal lines
    public var showHorizontalLines: Bool = true

    /// Flag indicated whether to show the yAxis
    public var showYAxis: Bool = true

    /// Closure for formatting the y axis values
    public var yAxisFormatter: ((Double) -> String)?

    /// Flag indicated whether to show the xAxis
    public var showXAxis: Bool = true

    /// Tint of the Average line
    public var avgTintColor: UIColor = .systemBlue

    /// Foreground color of the axis labels
    public var axisTintColor: UIColor = .label

    /// Color of the horizontal lines
    public var horizontalLineTintColor: UIColor = .lightGray

    /// Font of the x-axes values
    public var xAxisFont = UIFont.systemFont(ofSize: 12)

    /// Font of the x-axes values
    public var yAxisFont = UIFont.systemFont(ofSize: 12)

    /// Actual  number of entries.
    open var numberOfEntries: Int {
        return baseEntries.count
    }

    /// Maximal visible entries
    public var maxVisibleCount: Int?

    /// The number of entries to be shown. If maxVisibibleCount is not set it will be the number of entries
    var _maxEntries: Int {
        return min(maxVisibleCount ?? Int.max, baseEntries.count)
    }

    /// Minimum number of entries. If there are less  entries than specified here, a minimum amout of entries will be added
    public var minEntryCount: Int?

    var _minEntryCount: Int {
        return max(minEntryCount ?? Int.min, numberOfEntries)
    }

    /// Minimum spacing between each point
    public var minSpacing: CGFloat?

    /// Spacing between each point
    open var spacing: CGFloat {
        return minSpacing ?? container.bounds.width * (0.2 / CGFloat(_maxEntries))
    }

    // TODO: Calculate left spacing internally
    /// Spacing for the yAxis values
    public var leftSpacing: CGFloat = 20

    /// If set to true number of x-axis labels will be set according to width
    public var autoFormatXAxis: Bool = true

    public var scrollViewWidthInsets: CGFloat = 0

    let scrollView: UIScrollView = .init()
    /// Contains all BarLayers
    let container: CALayer = .init()
    private let xAxisLayer: CALayer = .init()
    private let gridLayer: CALayer = .init()

    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    let topHorizontalLine: CGFloat = 110.0 / 100.0
    /// The lowest most horizitonal line in the chart will be 5% less than the lowest values in the chart
    let bottomHorizontalLine: CGFloat = 95.0 / 100.0

    /// Spacing for the average line
    private var rightAvgSpacing: CGFloat = 20

    /// Spacing between yAxis and container
    private var containerLeftMargin: CGFloat = 10

    /// Total content insets. Currently only left side is supported
    private var insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)

    /// Space at the bottom of the bar to show the title
    private var bottomSpace: CGFloat = 30

    private var useMinMaxRange: Bool = true

    var baseEntries: [BaseEntryModel] = [] {
        didSet {
            if !oldValue.isEmpty && baseEntries.count != oldValue.count {
                layoutSublayers(of: layer)
            }

            setNeedsDisplay()
        }
    }

    /// A flag indicated whether the entries have been updated or set
    var updatingEntries = false

    // MARK: Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }

    private func comminInit() {
        scrollView.layer.addSublayer(xAxisLayer)
        scrollView.layer.addSublayer(gridLayer)
        scrollView.layer.addSublayer(container)
        addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        backgroundColor = .clear
    }

    // MARK: Functions

    func notifyConstraintChanges() {
        fatalError("notifyConstraintChanges(): has not been implemented for BaseChartView")
    }

    public func updateEntries(entries _: [BaseEntryModel], animationDuration _: Double) {
        fatalError("updateEntries(): has not been implemented for BaseChartView")
    }

    func computeContentSize() -> CGSize {
        return CGSize(width: bounds.size.width, height: bounds.size.height)
    }

    override public func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == self.layer {
            let y = insets.top
            let contentXpos = (showYAxis ? (leftSpacing + containerLeftMargin) : 0) + insets.left
            let contentSize = computeContentSize()

            let contentWidth = max(contentSize.width, bounds.width - leftSpacing)
            // TODO: ContentWidth with average is weird
            // let width = contentWidth - x - (showAvgLine ? rightAvgSpacing : 0) + containerLeftMargin + insets.left
            let totalWidth = contentWidth + rightAvgSpacing + contentXpos
            let height = contentSize.height - (showXAxis ? bottomSpace : 0) + insets.top

            scrollView.contentSize = CGSize(width: totalWidth, height: contentSize.height)
            container.frame = CGRect(x: contentXpos, y: y, width: contentWidth, height: height)

            // TODO: Currently xAxis labels are overlapping, disabling maskToBounds helps with that for now
            scrollView.layer.masksToBounds = false
            container.masksToBounds = false
            gridLayer.masksToBounds = false

            xAxisLayer.frame = CGRect(x: contentXpos, y: y + container.frame.height, width: container.frame.width, height: showXAxis ? bottomSpace : 0)
            gridLayer.frame = CGRect(x: insets.left, y: y, width: contentXpos + container.frame.width + (showAvgLine ? rightAvgSpacing : 0) - insets.left, height: height)
            // gridLayer.frame = CGRect(x: insets.left, y: y, width: self.bounds.width, height: height)

            notifyConstraintChanges()
            setNeedsDisplay()
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        addXAxis()
        drawHorizontalLines()
    }

    func translateHeightValueToYPosition(value: Double) -> CGFloat {
        if let max = baseEntries.max()?.value, let min = baseEntries.min()?.value {
            if useMinMaxRange {
                let minMaxRange = CGFloat(max - min) * topHorizontalLine

                let height = container.frame.height * (1 - ((CGFloat(value) - CGFloat(min)) &/ minMaxRange))
                return height * bottomHorizontalLine
            } else {
                if value == 0 {
                    return container.frame.height
                }

                let norm = CGFloat(Double(value) &/ Double(max))
                return container.frame.height * (1 - norm)
            }
        }
        return container.frame.height
    }

    func calculateXPos(for index: Int) -> CGFloat {
        let width = container.bounds.width
        var entries = numberOfEntries
        if let min = minEntryCount {
            entries = (numberOfEntries > min) ? numberOfEntries : min
        }

        return CGFloat(index) * (width &/ CGFloat(entries))
    }

    func getXPostionForXAxis(for index: Int) -> CGFloat {
        return calculateXPos(for: index)
    }

    func widthForXLabel(for label: String, at _: Int) -> CGFloat {
        return label.widthOfString(usingFont: xAxisFont)
    }

    func getXLabel(for index: Int) -> String? {
        return baseEntries[safe: index]?.label
    }
}

extension BaseChartView {
    func addXAxis() {
        xAxisLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard showXAxis, numberOfEntries > 0 else {
            return
        }

        var gap = 1
        if autoFormatXAxis {
            if let maxWidth = baseEntries.compactMap({ $0.label.widthOfString(usingFont: xAxisFont) }).max() {
                let width = xAxisLayer.bounds.width
                let maxLabels = Int(Double(width) &/ Double(maxWidth))
                guard maxLabels > 0 else {
                    return
                }
                gap = (numberOfEntries / maxLabels) + 1
            }
        }

        for i in stride(from: 0, to: numberOfEntries, by: gap) {
            let textLayer = getDefaultTextLayer()
            guard baseEntries[safe: i] != nil else { continue }
            if let text = getXLabel(for: i) {
                textLayer.frame = CGRect(x: getXPostionForXAxis(for: i), y: bottomSpace / 3, width: widthForXLabel(for: text, at: i), height: bottomSpace)
                textLayer.string = text
                textLayer.font = xAxisFont
                textLayer.fontSize = xAxisFont.pointSize
                textLayer.backgroundColor = UIColor.clear.cgColor
                xAxisLayer.addSublayer(textLayer)
            }
        }
    }

    func drawHorizontalLines() {
        guard baseEntries.count > 0 else { return }
        gridLayer.sublayers?.removeAll()
        drawAvgLine()

        guard showYAxis else { return }
        var gridValues: [CGFloat] = [0, 0.5, 1]
        if numberOfEntries < 3 {
            gridValues = [0, 1]
        }

        if var maxValue = baseEntries.max()?.value, var minValue = baseEntries.min()?.value {
            if minValue == maxValue {
                gridValues = [0, 1]
            }
            minValue = minValue * bottomHorizontalLine
            maxValue = maxValue * topHorizontalLine
            let minMaxGap = ceil(CGFloat(maxValue - minValue))

            for value in gridValues {
                let height = value * gridLayer.frame.size.height

                var lineValue = 0
                lineValue = Int((1 - value) * minMaxGap) + Int(minValue)

                let textLayer = getDefaultTextLayer()
                let text = yAxisFormatter?(Double(lineValue)) ?? String(lineValue)
                let labelSize = text.sizeOfString(usingFont: yAxisFont)
                let lheight = max(height - (labelSize.height / 2), 0)
                textLayer.frame = CGRect(x: 0, y: lheight, width: labelSize.width, height: 40)
                textLayer.string = text
                textLayer.font = yAxisFont
                textLayer.fontSize = yAxisFont.pointSize
                gridLayer.addSublayer(textLayer)

                guard showHorizontalLines else { continue }
                let path = UIBezierPath()
                path.move(to: CGPoint(x: container.frame.origin.x - insets.left, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.maxX - insets.left, y: height))

                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = horizontalLineTintColor.cgColor
                lineLayer.lineWidth = 1
                gridLayer.addSublayer(lineLayer)
            }
        }
    }

    private func drawAvgLine() {
        guard showAvgLine else { return }
        let sum = baseEntries.reduce(0) { $0 + $1.value }
        let avg = sum / CGFloat(numberOfEntries)

        let path = UIBezierPath()
        let height = translateHeightValueToYPosition(value: avg)
        let x = showYAxis ? leftSpacing : 0
        path.move(to: CGPoint(x: x, y: height))
        path.addLine(to: CGPoint(x: gridLayer.frame.maxX, y: height))

        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = avgTintColor.cgColor
        lineLayer.lineWidth = 1

        lineLayer.lineDashPattern = [4, 4]
        gridLayer.addSublayer(lineLayer)

        let avgTextLayer = getDefaultTextLayer()
        let avgRounded = round(avg)
        let text = yAxisFormatter?(Double(avgRounded)) ?? String(avgRounded)
        let labelSize = text.sizeOfString(usingFont: yAxisFont)
        let lheight = height - (labelSize.height + 2)
        avgTextLayer.frame = CGRect(x: gridLayer.frame.size.width - rightAvgSpacing, y: lheight, width: rightAvgSpacing, height: 16)
        avgTextLayer.foregroundColor = avgTintColor.cgColor
        avgTextLayer.alignmentMode = .left
        avgTextLayer.string = text
        avgTextLayer.font = yAxisFont
        avgTextLayer.fontSize = yAxisFont.pointSize
        gridLayer.addSublayer(avgTextLayer)
    }

    private func getDefaultTextLayer() -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.foregroundColor = axisTintColor.resolvedColor(with: traitCollection).cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.isWrapped = true
        return textLayer
    }
}

extension BaseChartView {
    public func setChartOptions(_ options: [BaseChartViewOption]) {
        for option in options {
            switch option {
            case let .animationDuration(value):
                animationDuration = value
            case let .animationDelay(value):
                animationDelay = value
            case let .maxVisibleCount(value):
                maxVisibleCount = value
            case let .showAvgLine(value):
                showAvgLine = value
            case let .showHorizontalLines(value):
                showHorizontalLines = value
            case let .showXAxis(value):
                showXAxis = value
            case let .showYAxis(value):
                showYAxis = value
            case let .avgTintColor(value):
                avgTintColor = value
            case let .axisTintColor(value):
                axisTintColor = value
            case let .horizontalLineTintColor(value):
                horizontalLineTintColor = value
            case let .xAxisFont(value):
                xAxisFont = value
            case let .yAxisFont(value):
                yAxisFont = value
            case let .minEntryCount(value):
                minEntryCount = value
            case let .minSpacing(value):
                minSpacing = value
            case let .backgroundColor(value):
                backgroundColor = value
            case let .shouldAutoFormatXAxis(value):
                autoFormatXAxis = value
            case let .xAxisSpacing(value):
                bottomSpace = value
            case let .useMinMaxRange(value):
                useMinMaxRange = value
            case let .showScrollIndicator(value):
                scrollView.showsVerticalScrollIndicator = value
                scrollView.showsHorizontalScrollIndicator = value
            case let .scrollViewWidthInsets(value):
                scrollViewWidthInsets = value
            case let .isScrollable(value):
                scrollView.isScrollEnabled = value
            case let .insets(value):
                insets = value
            }
        }
    }
}
