////
////  UIViewController+AddChild.swift
////  Vought Showcase
////
////  Created by Burhanuddin Rampurawala on 06/08/24.
////
//
//import UIKit
//
///// Extension on UIViewController
//extension UIViewController {
//    
//    /// Add child view controller to container view
//    /// - Parameters:
//    ///  - viewController: Child view controller
//    ///  - containerView: Container view
//    func add(asChildViewController viewController: UIViewController,
//                    containerView: UIView) {
//        addChild(viewController)
//        containerView.addSubview(viewController.view)
//        viewController.view.frame = containerView.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth,
//                                                .flexibleHeight]
//        viewController.didMove(toParent:
//                                self)
//    }
//}


//
//  UIViewController+AddChild.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit

/// Extension on UIViewController
extension UIViewController {
    
    /// Add child view controller to container view
    /// - Parameters:
    ///  - viewController: Child view controller
    ///  - containerView: Container view
    func add(asChildViewController viewController: UIViewController,
                    containerView: UIView) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            viewController.view.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        viewController.didMove(toParent:
                                self)
    }
}

