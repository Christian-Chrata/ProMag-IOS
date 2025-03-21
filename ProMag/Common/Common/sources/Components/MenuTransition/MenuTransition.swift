//
//  MenuTransition.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public enum TransitionState {
    case present
    case dismiss
}

public protocol BottomViewController {
    var bottomView: UIView { get }
}

public class MenuTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private typealias Screens = (from: UIViewController, to: UIViewController)
    private var state: TransitionState = .present
    public let interactor = Interactor()
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.interactor = interactor
        return presentationController
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        let screens: Screens = (transitionContext.viewController(forKey: .from)!, transitionContext.viewController(forKey: .to)!)
        switch state {
        case .present:
            present(duration: duration, container: container, screens: screens, transitionContext: transitionContext)
        case .dismiss:
            dismiss(duration: duration, container: container, screens: screens, transitionContext: transitionContext)
        }
    }
}

extension MenuTransition: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .present
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        state = .dismiss
        return self
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension MenuTransition {
    private func parse(with viewController: UIViewController) -> BottomViewController? {
        if let navigationController = viewController as? UINavigationController,
           let viewController = navigationController.viewControllers.last {
            return parse(with: viewController)
        } else if let tabBarController = viewController as? UITabBarController,
                  let viewController = tabBarController.selectedViewController {
            return parse(with: viewController)
        } else {
            return viewController as? BottomViewController
        }
    }
    
    private func present(duration: TimeInterval, container: UIView, screens: Screens, transitionContext: UIViewControllerContextTransitioning) {
        container.insertSubview(screens.to.view, aboveSubview: screens.from.view)
        let bottomView = parse(with: screens.from)?.bottomView
        screens.to.view.clipsToBounds = true
        screens.to.view.frame = bottomView?.frame ?? .zero
        screens.to.view.layer.cornerRadius = bottomView?.layer.cornerRadius ?? 0
        screens.to.view.alpha = 0
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.frame = bottomView?.frame ?? .zero
        view.layer.cornerRadius = bottomView?.layer.cornerRadius ?? 0
        container.insertSubview(view, belowSubview: screens.to.view)
        UIView.animate(withDuration: duration, animations: {
            screens.to.view.alpha = 1
            screens.to.view.layer.cornerRadius = 21
            screens.to.view.frame = transitionContext.finalFrame(for: screens.to)
            view.layer.cornerRadius = 21
            view.frame = transitionContext.finalFrame(for: screens.to)
        }) { (_) in
            screens.to.view.clipsToBounds = false
            view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func dismiss(duration: TimeInterval, container: UIView, screens: Screens, transitionContext: UIViewControllerContextTransitioning) {
        let bottomView = parse(with: screens.to)?.bottomView
        let frame = bottomView?.frame ?? .zero
        guard let snapshot = screens.from.view.snapshotView(afterScreenUpdates: false) else { return }
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.frame = transitionContext.finalFrame(for: screens.from)
        view.layer.cornerRadius = screens.from.view.layer.cornerRadius
        view.addSubview(snapshot)
        snapshot.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        snapshot.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        snapshot.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.insertSubview(view, aboveSubview: screens.from.view)
        screens.from.view.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            view.layer.cornerRadius = bottomView?.layer.cornerRadius ?? 0
            view.frame = frame
            snapshot.alpha = 0
        }) { (_) in
            screens.from.view.alpha = 1
            view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
