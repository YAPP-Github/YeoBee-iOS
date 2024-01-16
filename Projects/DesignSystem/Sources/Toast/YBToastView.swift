//
//  YBToastViewController.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 1/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public enum ToastIcon { case warning, complete }

extension ToastIcon {
    var image: UIImage {
        switch self {
        case .warning: DesignSystemAsset.Icons.warning.image
        case .complete: DesignSystemAsset.Icons.complete.image
        }
    }
}

public class YBToastView : UIStackView {
    private lazy var titleLabel: UILabel = {
        UILabel()
    }()

    private lazy var iconImage: UIImageView = {
        UIImageView()
    }()


    public init(icon: ToastIcon, _ title: String) {
        super.init(frame: CGRect.zero)
        commonInit()

        self.iconImage.image = icon.image

        self.titleLabel.text = title
        self.titleLabel.numberOfLines = 1
        self.titleLabel.font = YBFont.body4.font
        self.titleLabel.textColor = YBColor.white.color
        addArrangedSubview(self.iconImage)
        addArrangedSubview(self.titleLabel)

        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: 18),
            iconImage.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 10
    }
}

public class ToastView : UIView {

    private let child: UIView
    private var toast: Toast?

    public init(
        child: UIView
    ) {
        self.child = child
        super.init(frame: .zero)

        addSubview(child)
    }

    public override func removeFromSuperview() {
      super.removeFromSuperview()
      self.toast = nil
    }

    public func createView(for toast: Toast) {
        self.toast = toast
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 24),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -24),
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])

        addSubviewConstraints()
        DispatchQueue.main.async {
            self.style()
        }
    }

    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        layer.cornerRadius = 10
        backgroundColor = YBColor.gray6.color

        addShadow()
    }

    private func addSubviewConstraints() {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
