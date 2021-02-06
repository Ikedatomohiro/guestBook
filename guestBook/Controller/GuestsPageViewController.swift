//
//  GuestsPageViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import PencilKit
import FirebaseFirestore

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
    fileprivate var pageNumber  : Int     = 1
    
    weak var guestupdateDelegate: GuestUpdateDelegate?
    
    init(_ event: Event,_ retuals: [Retual],_ guests: [Guest]) {
        self.event = event
        self.retuals = retuals
        self.guests = guests
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: .none)
        self.guestupdateDelegate = self
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
        
        print("back!")
        
    }
    
    fileprivate func setGuestData() {
        // 初めて入力画面に入るときと最後のページが使われていないときは白紙のページを1つ追加して白紙ページを表示する
        if guests.count == 0 || self.guests.last != Guest(id: "new", retualList: retuals) {
            // 空のguestを配列に追加
            var newGuest = Guest(id: "new", retualList: self.retuals)
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
        dataSource = self
        delegate = self
    }
    
}
extension GuestsPageViewController: UIPageViewControllerDataSource {
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        // guestsを操作するindexをセット
        setIndex(currentIndex, viewControllerAfter: true)
        // 最後のページ以前でページが進められたとき
        if nextIndex <= guests.count - 1 {
            let guestVC = GuestViewController(guest: guests[nextIndex], retuals: retuals)
            guestVC.guestupdateDelegate = self
            return guestVC
            // 遷移前のページが初期状態の場合、そのままのページを使う
        } else if guests[prevIndex] == Guest(id:"new", retualList: retuals)  {
            // 新しいページではなく最終ページのindexをそのまま使う。
            currentIndex = prevIndex
            let guestVC = GuestViewController(guest: guests[prevIndex], retuals: retuals)
            guestVC.guestupdateDelegate = self
            return guestVC
            // 最後のページにデータが入っているときにページが進められたとき
        } else {
            var newGuest = Guest(id: "new", retualList: retuals)
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
        // guestsを操作するindexをセット
        setIndex(currentIndex, viewControllerAfter: false)
        guard nextIndex >= 0 else {
            // 1ページ目のときはページを戻す動作をしない
            nextIndex = 0
            return nil
        }
        
        let guestVC = GuestViewController(guest: guests[nextIndex], retuals: retuals)
        guestVC.guestupdateDelegate = self
        
        return guestVC
    }
    
    // GuestControllerにセットおよび保存するguestsのindexを作成
    func setIndex(_ targettIndex: Int, viewControllerAfter: Bool) -> Void {
        if viewControllerAfter == true {
            nextIndex = targettIndex + 1
        } else if viewControllerAfter == false {
            nextIndex = targettIndex - 1
        }
        prevIndex = targettIndex
        currentIndex = nextIndex
        return
    }
}

extension GuestsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("willTransitionTo")
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("didFinishAnimating")
        // ページめくりが完了したとき
        if completed {
            guard let guestController = pageViewController.viewControllers?.first as? GuestViewController else { return }
            // ページめくりが完了したときに保存
            guestupdateDelegate?.updateCloud(guest: guests[prevIndex])
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
    
    func updateCloud(guest: Guest) {
        if guest == Guest(id: "new", retualList: retuals) {
            return()
        }
        if guest.id == "new" {
            let documentRef = Guest.registGuest(guest: guest, eventId: event.eventId)
            let index = guests.firstIndex(where: {$0.id == "new"})
            if index != nil {
                guests[index!] = guest
                guests[index!].id = documentRef.documentID
            }
            if guest.guestNameImageData != nil {
                
            }
        } else {
            Guest.updateGuest(guest: guest, eventId: event.eventId)
            let index = guests.firstIndex(where: {$0.id == guest.id})
            if index != nil {
                guests[index!] = guest
            }
            
        }
    }
    
    func throwOcrApi() {
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
}
