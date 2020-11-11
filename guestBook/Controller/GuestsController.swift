//
//  GuestsController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import PencilKit

class GuestsController: UIPageViewController {

    fileprivate let retualArray:[String] = ["通夜", "告別式"]

//    private var pageControl: UIPageControl!
    
    fileprivate var guests: [Guest] = []
    fileprivate var currentIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupPageViewController()
    }
    
    fileprivate func fetchData() {
        guests = [Guest(id: "aa", name: "A"),
                  Guest(id: "bb", name: "B"),
                  Guest(id: "cc", name: "C")]
        if guests.count > 0 {
            let lastIndex = guests.count - 1
            currentIndex = lastIndex
            let guestController = GuestController(guest: guests[lastIndex])
            setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
        } else {
            let newGuest = Guest(id: "", name: "NEW")
            guests.append(newGuest)
            currentIndex = 0
            let guestController = GuestController(guest: newGuest)
            setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
            view.layoutIfNeeded()
        }
    }
    fileprivate func setupPageViewController() {
//        let guestController = GuestController(guest: Guest(id: "", name: ""))
//        setViewControllers([guestController], direction: .forward, animated: false, completion: nil)
        view.backgroundColor = .white
        dataSource = self
        delegate = self
    }
}
extension GuestsController: UIPageViewControllerDataSource {
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        let nextIndex = currentIndex + 1
        currentIndex = nextIndex
        if nextIndex <= guests.count - 1 {
            return GuestController(guest: guests[nextIndex])
        } else {
            let newGuest = Guest(id: "", name: "NEW")
            guests.append(newGuest)
            return GuestController(guest: newGuest)
        }
    }
    
    // 右にスワイプ（戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        let prevIndex = currentIndex - 1
        guard prevIndex >= 0 else { return nil }
        currentIndex = prevIndex
        return GuestController(guest: guests[prevIndex])
    }
}

extension GuestsController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
        if completed {
            guard let guestController = pageViewController.viewControllers?.first as? GuestController else { return }
            if let index = guests.firstIndex(where: {$0.id == guestController.guest.id}) {
                currentIndex = index
            } else {
                fatalError()
            }
        } else {
            guard let previousViewController = previousViewControllers.first as? GuestController else { return }
            if let index = guests.firstIndex(where: {$0.id == previousViewController.guest.id}) {
                currentIndex = index
            } else {
                fatalError()
            }
        }
    }
}
