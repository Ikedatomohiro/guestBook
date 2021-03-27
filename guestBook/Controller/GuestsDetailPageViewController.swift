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
    var tmpIndex: Int
    
    init(guests: [Guest], index: Int) {
        self.guests = guests
        self.currentIndex = index
        self.tmpIndex = index
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
        if currentIndex == 0 { return nil }
        tmpIndex = currentIndex - 1
//        setIndex(currentIndex, viewControllerAfter: false)
        let guest = guests[currentIndex - 1]
        let guestDetailVC = GuestDetailViewController(guest: guest)
        return guestDetailVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        if currentIndex == guests.count - 1 { return nil }
        tmpIndex = currentIndex + 1
//        setIndex(currentIndex, viewControllerAfter: true)
        let guest = guests[currentIndex + 1]
        let guestDetailVC = GuestDetailViewController(guest: guest)
        return guestDetailVC
    }
    
    // GuestControllerにセットおよび保存するguestsのindexを作成
//    func setIndex(_ targettIndex: Int, viewControllerAfter: Bool) -> Void {
//        // ページ進むとき
//        if viewControllerAfter == true {
//            nextIndex = targettIndex + 1
//            // ページ戻るとき
//        } else if viewControllerAfter == false {
//            nextIndex = targettIndex - 1
//        }
//        prevIndex = targettIndex
//        currentIndex = nextIndex
//        return
//    }
}

extension GuestsDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
        if completed {
            currentIndex = tmpIndex
        }
    }
}
