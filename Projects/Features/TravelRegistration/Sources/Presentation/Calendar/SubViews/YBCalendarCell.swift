//
//  YBCalendarCell.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import FSCalendar

public enum SelectionType {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

public class YBCalendarCell: FSCalendarCell {
    public static let identifier = "YBCalendarCell"
    
    public weak var circleImageView: UIImageView?
    public weak var selectionLayer: CAShapeLayer?
    public weak var roundedLayer: CAShapeLayer?

    public var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = YBColor.brightGreen.color.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel?.layer)
        self.selectionLayer = selectionLayer

        let roundedLayer = CAShapeLayer()
        roundedLayer.fillColor = YBColor.mainGreen.color.cgColor
        roundedLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(roundedLayer, below: self.titleLabel?.layer)
        self.roundedLayer = roundedLayer

        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        self.backgroundView = view
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.selectionLayer?.frame = self.contentView.bounds
        self.roundedLayer?.frame = self.contentView.bounds

        let contentHeight = self.contentView.frame.height
        let contentWidth = self.contentView.frame.width

        let selectionLayerBounds = selectionLayer?.bounds ?? .zero
        let selectionLayerWidth = selectionLayer?.bounds.width ?? .zero
        let roundedLayerHeight = roundedLayer?.frame.height ?? .zero
        let roundedLayerWidth = roundedLayer?.frame.width ?? .zero
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        switch selectionType {
        case .middle:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = true

            let selectionRect = selectionLayerBounds
                .insetBy(dx: 0.0, dy: 4.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

        case .leftBorder:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = false

            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 4, dy: 4)
                .offsetBy(dx: selectionLayerWidth / 4, dy: 0.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath

        case .rightBorder:
            self.selectionLayer?.isHidden = false
            self.roundedLayer?.isHidden = false

            let selectionRect = selectionLayerBounds
                .insetBy(dx: selectionLayerWidth / 4, dy: 4)
                .offsetBy(dx: -selectionLayerWidth / 4, dy: 0.0)
            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath

            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath

        case .single:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = false

            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
                              y: contentHeight / 2 - diameter / 2,
                              width: diameter,
                              height: diameter)
                .insetBy(dx: 2.5, dy: 2.5)
            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath

        case .none:
            self.selectionLayer?.isHidden = true
            self.roundedLayer?.isHidden = true
        }
    }
}
