//
//  GestureHandler.swift
//  ContainerDownload
//
//  Created by Akash on 27/03/24.
//

import Foundation
import UIKit

class GestureHandler{
    static let handle = GestureHandler()
    private var navigationController: UINavigationController?
    
    private init(){ }
    
    func backGesture(controller: UINavigationController,view: UIView){
        self.navigationController = controller
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc private func backGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) { // pop view Controller
        if recognizer.state == .ended {
            navigationController?.popViewController(transitionType: .fade, animated: true)
        }
    }
}
