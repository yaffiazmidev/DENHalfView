//
//  DENHalfViewController.swift
//
//  Created by DENAZMI on 11/09/24.
//

import UIKit

public class DENHalfViewController: UIViewController {
    
    private let halfView: DENHalfView
    
    public init(customView: DENHalfView = DENHalfView()) {
        self.halfView = customView
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    public override func loadView() {
        view = halfView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        halfView.presentHalfView()
    }
}

extension DENHalfViewController {
    public func animateContainerHeight(_ height: CGFloat) {
        halfView.animateContainerHeight(height)
    }
    
    public func animateDismissView(completion: (() -> Void)? = nil) {
        halfView.animateDismissView(completion: completion)
    }
}
