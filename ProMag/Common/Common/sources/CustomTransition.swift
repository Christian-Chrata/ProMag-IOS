//
//  CustomTransition.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public class CustomPresentationController: UIPresentationController {
    private var chrome: UIView = UIView()
    var interactor: Interactor? = nil
    var direction: CGFloat = 0
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
              let presentedView = presentedView else { return .zero }
        
        let inset: CGFloat = 0
        
        var safeAreaFrame: CGRect = .zero
        safeAreaFrame = containerView.bounds
            .inset(by: containerView.safeAreaInsets)
        
        let targetWidth = safeAreaFrame.width - (2 * inset)
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow).height
        
        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += safeAreaFrame.height - targetHeight - inset
        frame.size.width = targetWidth
        frame.size.height = targetHeight + safeAreaFrame.height
        return frame
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        chrome.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        chrome.alpha = 0.0
        chrome.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        )
        presentedViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
    }
    
    @objc
    private func panGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: sender.view)
        let verticalMovement = translation.y / sender.view!.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            presentingViewController.dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
            ? interactor.finish()
            : interactor.cancel()
        default:
            break
        }
    }
    
    public override func containerViewWillLayoutSubviews() {
        chrome.frame = containerView!.bounds
        presentedView?.center = .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        containerView?.insertSubview(chrome, at: 0)
        presentedViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { (_) in
                self.chrome.alpha = 1.0
            }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        presentedViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { (_) in
                self.chrome.alpha = 0.0
            }, completion: nil)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            chrome.removeFromSuperview()
        }
    }
    
    @objc
    private func tapGesture(sender: UIGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

public class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var state: TransitionState = .present
    let interactor = Interactor()
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.interactor = interactor
        return presentationController
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        switch state {
        case .present:
            present(duration: duration, container: container, transitionContext: transitionContext)
        case .dismiss:
            dismiss(duration: duration, container: container, transitionContext: transitionContext)
        }
    }
}

extension CustomTransition: UIViewControllerTransitioningDelegate {
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
}

extension CustomTransition {
    private func present(duration: TimeInterval, container: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)!
        let to = transitionContext.viewController(forKey: .to)!
        let toFinalFrame = transitionContext.finalFrame(for: to)
        container.insertSubview(to.view, aboveSubview: from.view)
        to.view.frame = CGRect(x: 0, y: toFinalFrame.height, width: toFinalFrame.width, height: toFinalFrame.height)
        UIView.animate(withDuration: duration, animations: {
            to.view.frame = CGRect(x: 0, y: 0, width: toFinalFrame.width, height: toFinalFrame.height)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func dismiss(duration: TimeInterval, container: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.viewController(forKey: .from)!
        let fromFinalFrame = transitionContext.finalFrame(for: from)
        UIView.animate(withDuration: duration, animations: {
            from.view.frame = CGRect(x: 0, y: container.bounds.height, width: fromFinalFrame.width, height: fromFinalFrame.height)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
