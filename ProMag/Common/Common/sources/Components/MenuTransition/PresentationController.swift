//
//  PresentationController.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public class PresentationController: UIPresentationController {
    private var chrome: UIView = UIView()
    var interactor: Interactor? = nil
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        let navbar: CGFloat = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + UIApplication.shared.statusBarFrame.height
        return CGRect(x: 0, y: navbar, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-navbar)
    }
    
    public override var presentedView: UIView? {
        super.presentedView?.frame = frameOfPresentedViewInContainerView
        return super.presentedView
    }
    
    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
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
        guard let interactor = interactor else { return }
        let progress = TransitionHelper
            .calculateProgress(translationInView: sender.translation(in: sender.view),
                               viewBounds: sender.view!.bounds,
                               direction: .Down)
        TransitionHelper
            .mapGestureStateToInteractor(gestureState: sender.state,
                                         progress: progress,
                                         interactor: interactor) { state in
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    switch state {
                    case .began:
                        self.presentingViewController.dismiss(animated: true, completion: nil)
                    default: break
                    }
                }
        }
    }
    
    public override func containerViewWillLayoutSubviews() {
        chrome.frame = containerView!.bounds
        presentedView?.roundCorners([.topLeft, .topRight], radius: 21)
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
    
    @objc private func tapGesture(sender: UIGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
