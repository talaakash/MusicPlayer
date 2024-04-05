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
    var lastSelectedView = UIView()
    var mainView = UIView()
    private var previousScale: CGFloat = 1.0
    var lastRotation: CGFloat = 0
    private var lastScale: CGFloat = 1
    private var navigationController: UINavigationController?
    private let closeButton = UIButton(type: .custom)
    
    private init(){
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .red
        closeButton.addTarget(self, action: #selector(removeView(_:)), for: .touchUpInside)
    }
    
    func backGesture(controller: UINavigationController,view: UIView){
        self.navigationController = controller
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backGesture(_:)))
        edgePanGesture.edges = .left
        view.addGestureRecognizer(edgePanGesture)
    }
    
    func deSelectLastView(){
        lastSelectedView.layer.borderWidth = 0
        lastSelectedView = UIView()
        closeButton.removeFromSuperview()
    }
    
    func adjustClosePosition(){
        closeButton.frame = CGRect(x: lastSelectedView.bounds.width - 21, y: -20, width: 40, height: 40)
        lastSelectedView.addSubview(closeButton)
    }
    
    func viewEditGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveViewPosition(_:)))
        mainView.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeSizeOfView(_:)))
        mainView.addGestureRecognizer(pinchGesture)
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateGesture(_:)))
        mainView.addGestureRecognizer(rotateGesture)
    }
    
    @objc private func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        guard sender.view != nil else { return }
        if sender.state == .began || sender.state == .changed {
            lastSelectedView.transform = lastSelectedView.transform.rotated(by: sender.rotation - lastRotation)
            lastRotation = sender.rotation
            NotificationCenter.default.post(name: NSNotification.Name.lastRotation, object: nil, userInfo: ["lastRotation": lastRotation])
        } else if sender.state == .ended {
            lastRotation = 0
        }
    }

    @objc private func changeSizeOfView(_ gesture: UIPinchGestureRecognizer) {  // Resize View
        if (gesture.state == UIGestureRecognizer.State.changed) {
            let scaleSpeed: CGFloat = 0.02 // Adjust the scale speed factor as needed
            let scale = 1.0 + ((gesture.scale - 1.0) * scaleSpeed)
            let newTransform = lastSelectedView.transform.scaledBy(x: scale, y: scale)
            lastSelectedView.transform = newTransform
            if let label = lastSelectedView as? UILabel{
                label.adjustFontSizeToFitLabel()
            }
            adjustClosePosition()
        }
    }
    
    @objc private func moveViewPosition(_ gesture: UIPanGestureRecognizer) {   // For move view
        let translation = gesture.translation(in: mainView)
        switch gesture.state {
        case .changed:
            lastSelectedView.center = CGPoint(x: lastSelectedView.center.x + translation.x, y: lastSelectedView.center.y + translation.y)
            gesture.setTranslation(.zero, in: lastSelectedView)
        default:
            break
        }
    }
    
    @objc private func backGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) { // pop view Controller
        if recognizer.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func removeView(_ sender: UIButton) {
        lastSelectedView.removeFromSuperview()
    }
}
