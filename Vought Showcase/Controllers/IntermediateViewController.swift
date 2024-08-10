//
//  IntermediateViewController.swift
//  Vought Showcase
//
//  Created by JJMac on 10/08/24.
//

import UIKit

class IntermediateViewController: UIViewController {
    //MARK: - properties
    private var button: UIButton = UIButton(type: .system)
    private var label: UILabel = UILabel(frame: .zero)
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    private func configureUI(){
        configureLabel()
        configureButton()
    }
    
    private func configureButton(){
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("View Story", for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 10
        
        let padding: CGFloat = 4.0
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: padding)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: -padding)
        
        button.addTarget(self, action: #selector(viewStoryClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    private func configureLabel(){
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vought Showcase"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func viewStoryClicked(){
        // Create a carousel item provider
        let carouselItemProvider = CarouselItemDataSourceProvider()
        
        // Create carouselViewController
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        
        pushCVC(viewController: carouselViewController)
        
//        navigationController?.pushViewController(carouselViewController, animated: true)
    }
    
    func pushCVC(viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.4 // Duration of the animation
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(viewController, animated: false)
    }

    
    

    

}
