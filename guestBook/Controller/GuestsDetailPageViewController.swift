//
//  GuestsDetailPageViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/17.
//

import UIKit

class GuestsDetailPageViewController: UIPageViewController {
    fileprivate var guests:[Guest]
    
    var currentIndex: Int = 0
    var prevIndex: Int = 0
    var nextIndex: Int = 0
    
    init(guests: [Guest], index: Int) {
        self.guests = guests
        self.currentIndex = index
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGuestData()
        setupPageViewController()
    }
    
    fileprivate func setGuestData() {
        let guestDetailVC = GuestDetailViewController(guests: guests, index: currentIndex)
        self.setViewControllers([guestDetailVC], direction: .forward, animated: true, completion: nil)
        self.view.layoutIfNeeded()

    }
    
    fileprivate func setupPageViewController() {
        view.backgroundColor = .white
        self.dataSource = self
        self.delegate = self
    }
}

// MARK:- Extensions
extension GuestsDetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let guestDetailVC = GuestDetailViewController(guests: guests, index: currentIndex)
        return guestDetailVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let guestDetailVC = GuestDetailViewController(guests: guests, index: currentIndex)
        return guestDetailVC
        
    }
    
}

extension GuestsDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
    }
}
