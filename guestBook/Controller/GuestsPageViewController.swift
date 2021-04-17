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
    fileprivate let relations: [Relation]
    fileprivate let groups: [Group]
    var guests: [Guest]
    var updateGuestParam = Set<String>()
    
    fileprivate var listeners = [ListenerRegistration]() // リスナーを保持する変数
    var currentIndex: Int = 0
    fileprivate let storage = Storage.storage().reference(forURL: Keys.firestoreStorageUrl)
    let guestUpdateQueue = DispatchQueue.global(qos: .userInitiated)
    
    init(_ event: Event, _ retuals: [Retual], _  relations: [Relation], _ groups: [Group] , _ guests: [Guest]) {
        self.event = event
        self.retuals = retuals
        self.relations = relations
        self.groups = groups
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
        // 戻るボタンが押されたときに画像解析して保存する
        guestUpdateQueue.async {
            // 変更があったときに画像解析して保存する。
            if self.updateGuestParam.count == 0 { return }
            self.analizeHandWriteAndUpdateGuestToCloud(guest: self.guests[self.currentIndex])
        }
    }
    
    fileprivate func setGuestData() {
        // 初めて入力画面に入るときと最後のページが使われていないときは白紙のページを1つ追加して白紙ページを表示する
        if guests.count == 0 || self.guests.last != Guest("new", retuals, relations, groups) {
            // 空のguestを配列に追加
            var newGuest = Guest("new", retuals, relations, groups)
            newGuest.pageNumber = self.guests.count + 1
            self.guests.append(newGuest)
        }
        let lastIndex = self.guests.count - 1
        let guest = guests[lastIndex]
        let guestVC = GuestViewController(guest: guest, retuals: retuals, relations: relations, groups: groups)
        // ページ管理用のindexをセット
        guestVC.index = lastIndex
        // データ変化比較用のguestをセット
        currentIndex = lastIndex
        // 参加者情報登録用のdelegateをセット
        guestVC.guestupdateDelegate = self
        self.setViewControllers([guestVC], direction: .forward, animated: true, completion: nil)
        self.view.layoutIfNeeded()
    }
    
    fileprivate func setupPageViewController() {
        view.backgroundColor = .white
        self.dataSource = self
        self.delegate = self
    }
}

// MARK:- Extensions
extension GuestsPageViewController: UIPageViewControllerDataSource {
    // 右にスワイプ（戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")
        let prevIndex = ((viewController as? GuestViewController)?.index)! - 1
        // 1ページ目のときはページを戻す動作をしない
        if currentIndex == 0 || prevIndex < 0 { return nil }
        let guest = guests[prevIndex]
        let guestVC = GuestViewController(guest: guest, retuals: retuals, relations: relations, groups: groups)
        guestVC.index = prevIndex
        guestVC.guestupdateDelegate = self
        return guestVC
    }
    
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        let nextIndex = ((viewController as? GuestViewController)?.index)! + 1
        // 遷移前のページが初期状態の場合、ページをめくらない
        if guests[currentIndex] == Guest("new", retuals, relations, groups)  {
            return nil
        }
        // guestの初期値をセット
        var guest = Guest("new", retuals, relations, groups)
        // 最後のページ以前でページが進められたときのguestをセット
        if nextIndex <= guests.count - 1 {
            guest = guests[nextIndex]
            // 最後のページにデータが入っているときにページが進められたときのguestをセット
        } else {
            guests.append(guest)
        }
        let guestVC = GuestViewController(guest: guest, retuals: retuals, relations: relations, groups: groups)
        guestVC.index = nextIndex
        guestVC.guestupdateDelegate = self
        return guestVC
    }
    
    func updateGuestCardToCloud(guest: Guest, result: Dictionary<String, String>) {
        if guest == Guest("new", retuals, relations, groups) {
            return()
        }
        if guest.id == "new" {
            // Firestoreにデータを保存
            let documentRef = Guest.registGuest(guest, event.eventId, result)
            if let index = guests.firstIndex(where: {$0.id == "new"}) {
                guests[index] = guest
                guests[index].id = documentRef.documentID
            }
        } else {
            Guest.updateGuest(guest, event.eventId, result)
        }
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
            // ページめくりが完了したときに画像解析して保存
            guestUpdateQueue.async {
                // 変更があったときに画像解析して保存する。
                if self.updateGuestParam.count == 0 { return }
                self.analizeHandWriteAndUpdateGuestToCloud(guest: self.guests[self.currentIndex])
                // 更新対象パラメータ初期化
                self.updateGuestParam = []
            }
            guard let changedIndex = (pageViewController.viewControllers as! [GuestViewController]).first?.index else { return }
            currentIndex = changedIndex
            // ページをめくり始めたが、元のページに戻ったとき
        } else {
            guard let changedIndex = (pageViewController.viewControllers as! [GuestViewController]).first?.index else { return }
            guard changedIndex != currentIndex else { return }
            currentIndex = changedIndex
        }
    }
    
    func analizeHandWriteAndUpdateGuestToCloud(guest: Guest) {
        // 画像解析により手書き文字のテキストを取得しguestを更新
        AnalizeHandWrite.analizeText(guest: guest, updateGuestParam: updateGuestParam) { (result) in
            // 画像解析が完了したら保存する
            apiQueueGroup.notify(queue: .main) {
                self.updateGuestCardToCloud(guest: guest, result: result)
            }
        }
    }
}

extension GuestsPageViewController: GuestCardUpdateDelegate {
    func update(guest: Guest, updateGuestParam: Set<String>) {
        if let index = guests.firstIndex(where: {$0.id == guest.id}) {
            guests[index] = guest
            self.updateGuestParam = updateGuestParam
        }
    }
}
