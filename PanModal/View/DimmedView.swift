//
//  DimmedView.swift
//  PanModal
//
//  Copyright © 2017 Tiny Speck, Inc. All rights reserved.
//

import UIKit

/**
 A dim view for use as an overlay over content you want dimmed.
 */
public class DimmedView: UIView {

    /**
     Represents the possible states of the dimmed view.
     max, off or a percentage of dimAlpha.
     */
    enum DimState {
        case max
        case off
        case percent(CGFloat)
    }

    // MARK: - Properties

    /**
     The state of the dimmed view
     */
    var dimState: DimState = .off {
        didSet {
            switch dimState {
            case .max:
                alpha = dimAlpha
            case .off:
                alpha = 0.0
            case .percent(let percentage):
                let val = max(0.0, min(1.0, percentage))
                alpha = dimAlpha * val
            }
        }
    }
    
    var passThoughView: UIView?

    /**
     The closure to be executed when a tap occurs
     */
    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)?

    /**
     Tap gesture recognizer
     */
    private lazy var tapGesture: UIGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        t.cancelsTouchesInView = false
        return t
    }()

    private let dimAlpha: CGFloat

    // MARK: - Initializers

    init(dimAlpha: CGFloat = 0.7, color: UIColor = .black) {
        self.dimAlpha = dimAlpha
        super.init(frame: .zero)
        alpha = 0.0
        backgroundColor = color
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Event Handlers

    @objc private func didTapView() {
        didTap?(tapGesture)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView != self {
            return hitView
        }
        if let pass = passThoughView, let hit = pass.hitTest(point, with: event) {
            return hit
        }
        return self
    }

}
