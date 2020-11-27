//
//  GuestsController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import PencilKit
import FirebaseFirestore

class GuestsController: UIPageViewController {
    fileprivate let retualArray:[String] = ["通夜", "告別式"]
    fileprivate let event: Event
    
    fileprivate var guests: [Guest] = []
    fileprivate var guestId: String = ""
    fileprivate var guestName: String = ""
    fileprivate var createdAt: Date = Date()
    fileprivate var currentIndex: Int = 0
    fileprivate var db = Firestore.firestore()
    
    init(event: Event) {
        self.event = event
//        super.init(nibName: nil, bundle: nil)
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(event.eventId)

        fetchData()
        setupPageViewController()
    }
    
    fileprivate func fetchData() {
        db.collection("eventName").document(event.eventId).collection("guests").getDocuments() { (querySnapshot, err) in
            guard let docments = querySnapshot?.documents else { return }
            self.guests = docments.map({ (document) -> Guest in
                return Guest(document: document)
            })
            
//            let newGuest = Guest()
//            self.guests.append(newGuest)
            
            
            
            if self.guests.isEmpty {
                let lastIndex = self.guests.count - 1
                self.currentIndex = lastIndex
                let guestController = GuestController(guest: self.guests[lastIndex])
                self.setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
            } else {
    //            let newGuest = Guest(id: "", name: "NEW")
    //            guests.append(newGuest)
                let newGuest = Guest()  // 空のguestを設定したいが、やり方がわからない。ビルドできるがここで落ちる。
                self.guests.append(newGuest)
                self.currentIndex = 0
                self.db.collection("eventName").document(self.event.eventId).collection("guests").addDocument(data: ["guestName": ""," createdAt": Timestamp.self])
    //            guests.append(newGuest)
    //            currentIndex = 0
                let guestController = GuestController(guest: newGuest)
                self.setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
                self.view.layoutIfNeeded()
            }
        }
        
        db.collection("events").document(event.eventId)
        
        
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
//            let newGuest = Guest(id: "", name: "NEW")
//            guests.append(newGuest)
//            return GuestController(guest: newGuest)
            return nil

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
