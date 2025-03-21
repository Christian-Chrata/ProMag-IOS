//
//  TransitionHelper.swift
//  Common
//
//  Created by Christian Wiradinata on 17/12/22.
//

import UIKit

public enum Direction {
    case Up
    case Down
    case Left
    case Right
}

public class TransitionHelper {
    public static let percentThreshold:CGFloat = 0.3
    
    public static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: Direction) -> CGFloat {
        let pointOnAxis: CGFloat
        let axisLength: CGFloat
        switch direction {
        case .Up, .Down:
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .Left, .Right:
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis:Float
        let positiveMovementOnAxisPercent:Float
        switch direction {
        case .Right, .Down: // positive
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .Up, .Left: // negative
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    public static func mapGestureStateToInteractor(gestureState: UIGestureRecognizer.State, progress: CGFloat, interactor: Interactor?, completion: (UIGestureRecognizer.State) -> ()){
            guard let interactor = interactor else { return }
            switch gestureState {
            case .began:
                interactor.hasStarted = true
                completion(.began)
            case .changed:
                interactor.shouldFinish = progress > percentThreshold
                interactor.update(progress)
                completion(.changed)
            case .cancelled:
                interactor.hasStarted = false
                interactor.cancel()
                completion(.cancelled)
            case .ended:
                interactor.hasStarted = false
                interactor.shouldFinish
                    ? interactor.finish()
                    : interactor.cancel()
                completion(.ended)
            default:
                break
            }
        }
}
