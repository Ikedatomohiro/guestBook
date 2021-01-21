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
    fileprivate var listeners = [ListenerRegistration]() // リスナーを保持する変数
    
    fileprivate var guests      : [Guest] = []
    fileprivate var guestId     : String  = ""
    fileprivate var guestName   : String  = ""
    fileprivate var createdAt   : Date    = Date()
    fileprivate var currentIndex: Int     = 0
    fileprivate var prevIndex   : Int     = 0
    fileprivate var nextIndex   : Int     = 0
    fileprivate var pageNumber  : Int     = 1

    fileprivate var db                = Firestore.firestore()
    
    lazy var currentGuestController: GuestController = GuestController(guest: guests[currentIndex])
    
    
    init(event: Event) {
        self.event = event
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: .none)
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
        Guest.collectionRef(eventId: event.eventId).order(by:"createdAt").getDocuments() { (querySnapshot, error) in
            guard let docments = querySnapshot?.documents else { return }
            self.guests = docments.map({ (document) -> Guest in
                var guest = Guest(document: document)
                guest.pageNumber = self.pageNumber
                self.pageNumber += 1
                return guest
            })
            // 初めて入力画面に入るときと最後のページが使われていないときは白紙のページを1つ追加して白紙ページを表示する
             if self.guests.count == 0 || self.guests.last != Guest(id: "new") {
                // 空のguestを配列に追加
                var newGuest = Guest(id: "new")
                newGuest.pageNumber = self.guests.count + 1
                self.guests.append(newGuest)
             }
             let lastIndex = self.guests.count - 1
             self.currentIndex = lastIndex
             let guestController = GuestController(guest: self.guests[lastIndex])
             // 参加者情報登録用のdelegateをセット
             guestController.guestupdateDelegate = self
             self.setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
             self.view.layoutIfNeeded()
        }

    }
    
    
    fileprivate func setupPageViewController() {
        view.backgroundColor = .white
        dataSource = self
        delegate = self
 
    }

}
extension GuestsController: UIPageViewControllerDataSource {
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        nextIndex = currentIndex + 1
        currentIndex = nextIndex
        if nextIndex <= guests.count - 1 {
            let guestVC = GuestController(guest: guests[nextIndex])
            guestVC.guestupdateDelegate = self
//            guestVC.updateRetualDelegate = self
            return guestVC
        } else if guests.firstIndex(where: {$0.id == "new"}) != nil  {
            // id を"new"で仮作成したGuestに入力された要素を選択
            let index = guests.firstIndex(where: {$0.id == "new"})!
            let guestVC = GuestController(guest: guests[index])
            guestVC.guestupdateDelegate = self
//            guestVC.updateRetualDelegate = self
            return guestVC
        } else {
            var newGuest = Guest(id: "new")
            newGuest.pageNumber = guests.count + 1
            self.guests.append(newGuest)
            let guestVC = GuestController(guest: newGuest)
            guestVC.guestupdateDelegate = self
//            guestVC.updateRetualDelegate = self
           return guestVC
        }
    }
    
    // 右にスワイプ（戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        prevIndex = currentIndex - 1
        guard prevIndex >= 0 else {
            // 1ページ目のときはページを戻す動作をしない
            prevIndex = 0
            return nil
        }
        currentIndex = prevIndex

        let guestVC = GuestController(guest: guests[prevIndex])
        guestVC.guestupdateDelegate = self

        return guestVC
    }
 }


extension GuestsController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
        // ページめくりが完了したとき
        if completed {
            guard let guestController = pageViewController.viewControllers?.first as? GuestController else { return }
            if let index = guests.firstIndex(where: {$0.id == guestController.guest.id}) {
                currentIndex = index
            } else {
                currentIndex = guests.count
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

extension GuestsController: GuestUpdateDelegate {
    func update(guest: Guest) -> String {
        if (guest.id == "new") {
            let documentRef = Guest.registGuest(guest: guest, eventId: event.eventId)
            let index = guests.firstIndex(where: {$0.id == "new"})
            if index != nil {
                guests[index!] = guest
                guests[index!].id = documentRef.documentID
//            guest.id = documentRef.documentID   // idを変更できない。どこでletになっているかわからない。
            }
            return documentRef.documentID
        } else {
            Guest.updateGuest(guest: guest, eventId: event.eventId)
            let index = guests.firstIndex(where: {$0.id == guest.id})
            if index != nil {
                guests[index!] = guest
            }
            return guests[index!].id
        }
    }
    
}
