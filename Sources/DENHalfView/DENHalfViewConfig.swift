//
//  DENHalfViewConfig.swift
//
//  Created by DENAZMI on 11/09/24.
//

import Foundation

public struct DENHalfViewConfig {
    public var dismissibleHeight: CGFloat
    public var canSlideUp: Bool
    public var topRadius: CGFloat
    public var maxDimmedAlpha: CGFloat
    
    var currentContainerHeight: CGFloat = 300
    
    public var viewHeight: CGFloat {
        didSet {
            currentContainerHeight = viewHeight
            dismissibleHeight = viewHeight * 0.7
        }
    }
    
    public init(
        viewHeight: CGFloat = 300,
        dismissibleHeight: CGFloat = 200,
        canSlideUp: Bool = true,
        topRadius: CGFloat = 16.0,
        maxDimmedAlpha: CGFloat = 0.6
    ) {
        self.viewHeight = viewHeight
        self.dismissibleHeight = dismissibleHeight
        self.canSlideUp = canSlideUp
        self.topRadius = topRadius
        self.maxDimmedAlpha = maxDimmedAlpha
    }
}
