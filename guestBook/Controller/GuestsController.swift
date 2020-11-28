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
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: .none)
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
        db.collection("events").document(event.eventId).collection("guests").getDocuments() { (querySnapshot, error) in
            guard let docments = querySnapshot?.documents else { return }
            self.guests = docments.map({ (document) -> Guest in
                return Guest(document: document)
            })
            // 開くときは白紙のページを1つ追加して白紙ページを表示する
            let newGuest = Guest()
            // 配列に加える
            self.guests.append(newGuest)
            // Firestoreに空の情報を登録
            self.db.collection("events").document(self.event.eventId).collection("guests").addDocument(data: ["guestName": "", "id": "", "createdAt": Date()])
            let lastIndex = self.guests.count - 1
            self.currentIndex = lastIndex
            let guestController = GuestController(guest: self.guests[lastIndex])
            self.setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
            self.view.layoutIfNeeded()
        }
    }
    fileprivate func setupPageViewController() {
//        let guestController = GuestController(guest: Guest())
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
            let newGuest = Guest()
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
