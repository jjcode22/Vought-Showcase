//
//  CarouselViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import Foundation
import UIKit


final class CarouselViewController: UIViewController {
    
    /// Container view for the carousel
    @IBOutlet private weak var containerView: UIView!
    
    /// Carousel control with page indicator
    @IBOutlet private weak var carouselControl: UIPageControl!


    /// Page view controller for carousel
    private var pageViewController: UIPageViewController?
    
    //SegmentedProgressBar
    private var progressBar = SegmentedProgressBar(numberOfSegments: 4)
    
    /// Carousel items
    private var items: [CarouselItem] = []
    
    /// Current item index
    private var currentItemIndex: Int = 0 {
        didSet {
            // Update carousel control page
            self.carouselControl.currentPage = currentItemIndex
        }
    }

    /// Initializer
    /// - Parameter items: Carousel items
    public init(items: [CarouselItem]) {
        self.items = items
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageViewController()
        initCarouselControl()
        configureContainerView()
        initProgressBar()
        progressBar.startAnimation()
        removeSwipeGesture()
        navigationController?.navigationBar.isHidden = true
        print(containerView.subviews)
    }
    
    /// initalize container view
    private func configureContainerView(){
        containerView.backgroundColor = .black
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
        
        //tap gesture recognizers for left and right corners
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftTap))
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRightTap))
        
        // Setting the tap areas
        let tapAreaWidth: CGFloat = 80 // I have set the tap are as 80 from each sides.
        
        let leftTapArea = UIView(frame: CGRect(x: 0, y: 0, width: tapAreaWidth, height: containerView.bounds.height))
        leftTapArea.backgroundColor = .clear
        containerView.addSubview(leftTapArea)
        leftTapArea.addGestureRecognizer(leftTapGesture)
        
        let rightTapArea = UIView(frame: CGRect(x: containerView.bounds.width - tapAreaWidth, y: 0, width: tapAreaWidth, height: containerView.bounds.height))
        rightTapArea.backgroundColor = .clear
        containerView.addSubview(rightTapArea)
        rightTapArea.addGestureRecognizer(rightTapGesture)
    }
    
    
    /// Initialize page view controller
    private func initPageViewController() {

        // Create pageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,
        options: nil)

        // Set up pageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        pageViewController?.setViewControllers(
            [getController(at: currentItemIndex)], direction: .forward, animated: true)

        guard let theController = pageViewController else {
            return
        }
        
        // Add pageViewController in container view
        add(asChildViewController: theController,
            containerView: containerView)
        
    }
    
    func removeSwipeGesture(){
        //removing swipe gesture from each of the subviews in the pageViewController
        for view in self.pageViewController!.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }

    /// Initialize carousel control
    private func initCarouselControl() {
        // Set page indicator color
        carouselControl.currentPageIndicatorTintColor = UIColor.darkGray
        carouselControl.pageIndicatorTintColor = UIColor.lightGray
        
        // Set number of pages in carousel control and current page
        carouselControl.numberOfPages = items.count
        carouselControl.currentPage = currentItemIndex
        
        // Add target for page control value change
        carouselControl.addTarget(
                    self,
                    action: #selector(updateCurrentPage(sender:)),
                    for: .valueChanged)
    }
    
    ///initalize progressBar
//    private func initProgressBar() {
//        progressBar.delegate = self
//        containerView.addSubview(progressBar)
//        progressBar.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            progressBar.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 0),
//            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
//            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
//            progressBar.heightAnchor.constraint(equalToConstant: 8)
//
//        ])
//    }
    
    private func initProgressBar() {
        progressBar.delegate = self
        containerView.addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 6),
            progressBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: 6),
            progressBar.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        // Force the view to update its layout immediately
        progressBar.layoutIfNeeded()
    }


    /// Update current page
    /// Parameter sender: UIPageControl
    @objc func updateCurrentPage(sender: UIPageControl) {
        // Get direction of page change based on current item index
        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentItemIndex ? .forward : .reverse
        
        // Get controller for the page
        let controller = getController(at: sender.currentPage)
        
        // Set view controller in pageViewController
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        
        // Update current item index
        currentItemIndex = sender.currentPage
    }
    
    /// Get controller at index
    /// - Parameter index: Index of the controller
    /// - Returns: UIViewController
    private func getController(at index: Int) -> UIViewController {
        return items[index].getController()
    }
    
    @objc private func handleLeftTap() {
        // Navigate to the previous story
        let newIndex = currentItemIndex > 0 ? currentItemIndex - 1 : items.count - 1
        progressBar.rewind()
    }

    @objc private func handleRightTap() {
        // Navigate to the next story
        let newIndex = currentItemIndex + 1 < items.count ? currentItemIndex + 1 : 0
        progressBar.skip()
    }

}

// MARK: UIPageViewControllerDataSource methods
extension CarouselViewController: UIPageViewControllerDataSource {
    
    /// Get previous view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            // Check if current item index is first item
            // If yes, return last item controller
            // Else, return previous item controller
            if currentItemIndex == 0 {
                return items.last?.getController()
            }
            return getController(at: currentItemIndex-1)
        }

    /// Get next view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
           
            // Check if current item index is last item
            // If yes, return first item controller
            // Else, return next item controller
            if currentItemIndex + 1 == items.count {
                return items.first?.getController()
            }
            return getController(at: currentItemIndex + 1)
        }
}

// MARK: UIPageViewControllerDelegate methods
extension CarouselViewController: UIPageViewControllerDelegate {
    
    /// Page view controller did finish animating
    /// - Parameters:
    /// - pageViewController: UIPageViewController
    /// - finished: Bool
    /// - previousViewControllers: [UIViewController]
    /// - completed: Bool
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = items.firstIndex(where: { $0.getController() == visibleViewController }){
                currentItemIndex = index
            }
        }
}

// MARK: -  SegmentedProgressBarDelegate
extension CarouselViewController: SegmentedProgressBarDelegate{
    func segmentedProgressBarChangedIndex(index: Int) {
        // Update the page view controller to the new index
        let direction: UIPageViewController.NavigationDirection = index > currentItemIndex ? .forward : .reverse
        let controller = getController(at: index)
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        currentItemIndex = index
    }
    
    func segmentedProgressBarFinished() {
        //dimiss CarouselViewController when all members have finished showing up from topdown animation for Pop
        dismissCVC()
    }
    
    func dismissCVC() {
        //custom animation for popping the controller from top to down.
        let transition = CATransition()
        transition.duration = 0.4 // Duration of the animation
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }

    
    
}
