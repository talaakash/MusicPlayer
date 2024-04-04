//
//  Navigation+Extention.swift
//  AnimationPractice
//
//  Created by Akash on 01/04/24.
//

import Foundation
import UIKit

enum TransitionType: String{
    case fade = "fade"
    case moveIn = "moveIn"
    case push = "push"
    case reveal = "reveal"
    case cube = "cube"
    case suckEffect = "suckEffect"
    case oglFlip = "oglFlip"
    case rippleEffect = "rippleEffect"
    case pageCurl = "pageCurl"
    case pageUnCurl = "pageUnCurl"
    case cameraIrisHollowOpen = "cameraIrisHollowOpen"
    case cameraIrisHollowClose = "cameraIrisHollowClose"
}

extension UINavigationController{
    func customPush(_ viewController: UIViewController, transitionType: TransitionType, animated: Bool) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType(rawValue: transitionType.rawValue)
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func customPresent(_ viewControllerToPresent: UIViewController, transitionType: TransitionType, animated: Bool) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType(rawValue: transitionType.rawValue)
        view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
    }
    
    func popViewController(transitionType: TransitionType, animated: Bool){
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType(rawValue: transitionType.rawValue)
        view.window?.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
}
