//
//  GuestsDetailPageViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/17.
//

import UIKit

class GuestsDetailPageViewController: UIPageViewController {
    fileprivate var guests:[Guest]
    
    var currentIndex = 0
    
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
        let guest = guests[currentIndex]
        let guestDetailVC = GuestDetailViewController(guest: guest)
        guestDetailVC.index = currentIndex
        self.setViewControllers([guestDetailVC], direction: .forward, animated: true, completion: nil)
        self.view.layoutIfNeeded()

    }
    
    fileprivate func setupPageViewController() {
        view.backgroundColor = .white
        self.dataSource = self
        self.delegate = self
    }
    
    func moveGuestDetailPage(from fromIndex: Int, to toIndex: Int) {
        if currentIndex == toIndex { return }
        let guest = guests[toIndex]
        let guestDetailVC = GuestDetailViewController(guest: guest)
        var direction: UIPageViewController.NavigationDirection = .forward
        if currentIndex > toIndex {
            direction = .reverse
        }
        currentIndex = toIndex
        self.setViewControllers([guestDetailVC], direction: direction, animated: true, completion: nil)

    }
}

// MARK:- Extensions
extension GuestsDetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        let prevIndex = ((viewController as? GuestDetailViewController)?.index)! - 1
        if currentIndex == 0 { return nil }
        let guest = guests[prevIndex]
        let guestDetailVC = GuestDetailViewController(guest: guest)
        guestDetailVC.index = prevIndex
        return guestDetailVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        let nextIndex = ((viewController as? GuestDetailViewController)?.index)! + 1
        guard nextIndex <= guests.count - 1 else { return nil }
        let guest = guests[nextIndex]
        let guestDetailVC = GuestDetailViewController(guest: guest)
        guestDetailVC.index = nextIndex
        return guestDetailVC
    }
}

extension GuestsDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
        if completed {
            print("completed")
            guard let changedIndex = (pageViewController.viewControllers as! [GuestDetailViewController]).first?.index else { return }
            currentIndex = changedIndex
        } else {
            print("not completed")
            guard let changedIndex = (pageViewController.viewControllers as! [GuestDetailViewController]).first?.index else { return }
            guard changedIndex != currentIndex else { return }
            currentIndex = changedIndex
        }
    }
}
