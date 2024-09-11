//
//  DENHalfView.swift
//
//  Created by DENAZMI on 11/09/24.
//

import UIKit

public protocol DENHalfViewDelegate: AnyObject {
    func handleDismiss(_ animate: Bool)
    func didChangeSwipe(position: Double)
    func didEndSwipe(position: Double)
}

public class DENHalfView: UIView {
    
    private(set) lazy var dimmedView: UIView = UIView()
    private(set) lazy var containerView: UIView = UIView()
    private(set) lazy var customView: UIView = UIView()
    
    // keep current new height, initial is default height
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 100
    private var config: DENHalfViewConfig
    
    public weak var delegate: DENHalfViewDelegate?
    
    public init(config: DENHalfViewConfig = DENHalfViewConfig()) {
        self.config = config
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        containerViewHeightConstraint = nil
        containerViewBottomConstraint = nil
    }
    
    public func commonInit() {
        configureUI()
        setupGestureRecognizer()
    }
    
    public func presentHalfView() {
        animateShowDimmedView()
        animatePresentContainer()
    }
}

extension DENHalfView {
    private func setupGestureRecognizer() {
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        setupPanGesture()
    }
    
    private func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        containerView.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        // Drag to top will be minus value and vice versa
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        if !isDraggingDown && !config.canSlideUp { return }
        
        // New height is based on value of dragging plus current container height
        let newHeight = config.currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                layoutIfNeeded()
            }
            delegate?.didChangeSwipe(position: newHeight)
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < config.dismissibleHeight {
                animateDismissView { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.handleDismiss(false)
                }
            } else if newHeight < config.viewHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(config.viewHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(config.viewHeight)
            } else if newHeight > config.viewHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
            delegate?.didEndSwipe(position: newHeight)
        default:
            break
        }
    }
    
    @objc private func handleCloseAction() {
        animateDismissView { [weak self] in
            guard let self = self else { return }
            self.delegate?.handleDismiss(false)
        }
    }
}

extension DENHalfView {
    public func animateContainerHeight(_ height: CGFloat) {
        // Update container height
        animateChanges(duration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.layoutIfNeeded()
        }
        config.currentContainerHeight = height
    }

    // MARK: Present and dismiss animation
    private func animatePresentContainer() {
        // update bottom constraint in animation block
        animateChanges(duration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.layoutIfNeeded()
        }
    }

    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        animateChanges(duration: 0.4) {
            self.dimmedView.alpha = self.config.maxDimmedAlpha
        }
    }

    public func animateDismissView(completion: (() -> Void)? = nil) {
        // hide blur view
        animateChanges(duration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: {
            completion?()
        }
        
        // hide main view by updating bottom constraint in animation block
        animateChanges(duration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.config.currentContainerHeight
            self.layoutIfNeeded()
        }
    }
}

extension DENHalfView {
    private func configureUI() {
        config.dismissibleHeight = config.viewHeight * 0.7
        config.currentContainerHeight = config.viewHeight
        
        configureDimmedView()
        configureContainerView()
    }
    
    private func configureDimmedView() {
        dimmedView.alpha = 0
        dimmedView.backgroundColor = .black
        dimmedView.accessibilityIdentifier = "dimmedView"
        
        addSubview(dimmedView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = config.topRadius
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.clipsToBounds = true
        containerView.accessibilityIdentifier = "containerView"
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 100),
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: config.viewHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                              constant: config.viewHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func animateChanges(duration: TimeInterval, animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: { _ in completion?() })
    }
}

extension DENHalfViewDelegate {
    public func didEndSwipe(position: Double) {}
    
    public func didChangeSwipe(position: Double) {}
}
