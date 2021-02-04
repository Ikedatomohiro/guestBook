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
    fileprivate let event: Event
    fileprivate let retuals: [Retual]
    var guests: [Guest]
    fileprivate var listeners = [ListenerRegistration]() // リスナーを保持する変数
    fileprivate var guestId     : String  = ""
    fileprivate var guestName   : String  = ""
    fileprivate var createdAt   : Date    = Date()
    fileprivate var currentIndex: Int     = 0
    fileprivate var prevIndex   : Int     = 0
    fileprivate var nextIndex   : Int     = 0
    fileprivate var pageNumber  : Int     = 1

    
    lazy var currentGuestController: GuestController = GuestController(guest: guests[currentIndex], retuals: retuals)
    weak var guestupdateDelegate: GuestUpdateDelegate?

    
    init(_ event: Event,_ retuals: [Retual],_ guests: [Guest]) {
        self.event = event
        self.retuals = retuals
        self.guests = guests
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
        // 初めて入力画面に入るときと最後のページが使われていないときは白紙のページを1つ追加して白紙ページを表示する
        if self.guests.count == 0 || self.guests.last != Guest(id: "new", retualList: self.retuals) {
            // 空のguestを配列に追加
            var newGuest = Guest(id: "new", retualList: self.retuals)
            newGuest.pageNumber = self.guests.count + 1
            self.guests.append(newGuest)
        }
        let lastIndex = self.guests.count - 1
        self.currentIndex = lastIndex
        let guestController = GuestController(guest: self.guests[lastIndex], retuals: self.retuals)
        // 参加者情報登録用のdelegateをセット
        guestController.guestupdateDelegate = self
        self.setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
        self.view.layoutIfNeeded()
    }
    
    
    fileprivate func setupPageViewController() {
        view.backgroundColor = .white
        dataSource = self
        delegate = self
    }

    fileprivate func setGuestRetuals(retuals: [Retual]) {
//        for retual in retuals {
////            retual[retual["key"]] = retual["value"]
//        }
    }
}
extension GuestsController: UIPageViewControllerDataSource {
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
//        _ = guestupdateDelegate?.update(guest: guests[currentIndex])
        nextIndex = currentIndex + 1
        currentIndex = nextIndex
        if nextIndex <= guests.count - 1 {
            let guestVC = GuestController(guest: guests[nextIndex], retuals: retuals)
            guestVC.guestupdateDelegate = self
            return guestVC
        } else if guests.firstIndex(where: {$0.id == "new"}) != nil  {
            // id を"new"で仮作成したGuestに入力された要素を選択
            let index = guests.firstIndex(where: {$0.id == "new"})!
            let guestVC = GuestController(guest: guests[index], retuals: retuals)
            guestVC.guestupdateDelegate = self
            return guestVC
        } else {
            var newGuest = Guest(id: "new", retualList: retuals)
            newGuest.pageNumber = guests.count + 1
            self.guests.append(newGuest)
            let guestVC = GuestController(guest: newGuest, retuals: retuals)
            guestVC.guestupdateDelegate = self
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

        let guestVC = GuestController(guest: guests[prevIndex], retuals: retuals)
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
//            ここで保存できる？？
//            guestController.guestupdateDelegate = self
//            let guestId = guestupdateDelegate?.update(guest: guests[currentIndex])
//            if (guests[currentIndex].id == "new" && guestId != nil) {
//                guests[currentIndex].id = guestId!
//            }

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
