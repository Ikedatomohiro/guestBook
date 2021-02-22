//
//  GuestsPageViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import PencilKit
import FirebaseFirestore
import FirebaseStorage

class GuestsPageViewController: UIPageViewController {
    fileprivate let event: Event
    fileprivate let retuals: [Retual]
    var guests: [Guest]
    fileprivate var listeners = [ListenerRegistration]() // リスナーを保持する変数
    fileprivate var guestId: String   = ""
    fileprivate var guestName: String = ""
    fileprivate var createdAt: Date   = Date()
    var currentIndex: Int = 0
    var prevIndex: Int    = 0
    var nextIndex: Int    = 0
    fileprivate let storage = Storage.storage().reference(forURL: Keys.firestoreStorageUrl)
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        // 戻るボタンが押されたときに保存する
        updateGuestCardToCloud(guest: &guests[currentIndex])
    }
    
    fileprivate func setGuestData() {
        // 初めて入力画面に入るときと最後のページが使われていないときは白紙のページを1つ追加して白紙ページを表示する
        if guests.count == 0 || self.guests.last != Guest("new", retuals) {
            // 空のguestを配列に追加
            var newGuest = Guest("new", retuals)
            newGuest.pageNumber = self.guests.count + 1
            self.guests.append(newGuest)
        }
        let lastIndex = self.guests.count - 1
        currentIndex = lastIndex
        let guestController = GuestViewController(guest: guests[lastIndex], retuals: retuals)
        // 参加者情報登録用のdelegateをセット
        guestController.guestupdateDelegate = self
        self.setViewControllers([guestController], direction: .forward, animated: true, completion: nil)
        self.view.layoutIfNeeded()
    }
    
    fileprivate func setupPageViewController() {
        view.backgroundColor = .white
        self.dataSource = self
        self.delegate = self
    }
    
}

// MARK:- 
extension GuestsPageViewController: UIPageViewControllerDataSource {
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        // 遷移前のページが初期状態の場合、ページをめくらない
        if guests[currentIndex] == Guest("new", retuals)  {
            return nil
        }
        // guestsを操作するindexをセット
        setIndex(currentIndex, viewControllerAfter: true)
        // 最後のページ以前でページが進められたとき
        if nextIndex <= guests.count - 1 {
            let guestVC = GuestViewController(guest: guests[nextIndex], retuals: retuals)
            guestVC.guestupdateDelegate = self
            return guestVC
            // 最後のページにデータが入っているときにページが進められたとき
        } else {
            var newGuest = Guest("new", retuals)
            newGuest.pageNumber = guests.count + 1
            guests.append(newGuest)
            let guestVC = GuestViewController(guest: newGuest, retuals: retuals)
            guestVC.guestupdateDelegate = self
            return guestVC
        }
    }
    
    // 右にスワイプ（戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        if currentIndex == 0 {
            // 1ページ目のときはページを戻す動作をしない
            return nil
        }
        // guestsを操作するindexをセット
        setIndex(currentIndex, viewControllerAfter: false)
        let guestVC = GuestViewController(guest: guests[nextIndex], retuals: retuals)
        guestVC.guestupdateDelegate = self
        return guestVC
    }
    
    // GuestControllerにセットおよび保存するguestsのindexを作成
    func setIndex(_ targettIndex: Int, viewControllerAfter: Bool) -> Void {
        // ページ進むとき
        if viewControllerAfter == true {
            nextIndex = targettIndex + 1
            // ページ戻るとき
        } else if viewControllerAfter == false {
            nextIndex = targettIndex - 1
        }
        prevIndex = targettIndex
        currentIndex = nextIndex
        return
    }
    
    func updateGuestCardToCloud(guest: inout Guest) {
        if guest == Guest("new", retuals) {
            return()
        }
        Guest.updateText(guest: &guest)

        if guest.id == "new" {
            // Firestoreにデータを保存
            let documentRef = Guest.registGuest(guest, event.eventId)
            if let index = guests.firstIndex(where: {$0.id == "new"}) {
                guests[index] = guest
                guests[index].id = documentRef.documentID
            }
        } else {
            Guest.updateGuest(guest, event.eventId)
        }

    }

}
// MARK:- Extensions
extension GuestsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
        let grobalQueue = DispatchQueue.global(qos: .userInitiated)
        // ページめくりが完了したとき
        if completed {
            grobalQueue.async {
                // ページめくりが完了したときに保存
                self.updateGuestCardToCloud(guest: &self.guests[self.prevIndex])
            }

            // ページを捲り始めたが、元のページに戻ったとき
        } else {
            guard let previousViewController = previousViewControllers.first as? GuestViewController else { return }
            if let index = guests.firstIndex(where: {$0.id == previousViewController.guest.id}) {
                currentIndex = index
            } else {
                fatalError()
            }
        }
    }
}

extension GuestsPageViewController: GuestUpdateDelegate {
    func update(guest: Guest) {
        let index = guests.firstIndex(where: {$0.id == guest.id})
        if index != nil {
            guests[index!] = guest
        }
    }
    
}
