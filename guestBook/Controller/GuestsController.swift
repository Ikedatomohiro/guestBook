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
    
    fileprivate var listeners = [ListenerRegistration]()
    
    fileprivate var guests: [Guest] = []
    fileprivate var newGuest = Guest()
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

        fetchData()
        setupPageViewController()
    }
    
    fileprivate func fetchData() {
        db.collection("events").document(event.eventId).collection("guests").getDocuments(source: .cache) { (querySnapshot, error) in
            ~~
            ~~
            ~~
            
            let listener = db.collection("events").document(event.eventId).collection("guests").addSnapshotListener { (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New guest: \(diff.document.documentID)")
                        self.newGuest = Guest(document: diff.document)
                        self.guests.append(self.newGuest)
                    }
                }
            }
            listeners.append(listener)
        }
        
        db.collection("events").document(event.eventId).collection("guests").order(by:"createdAt").getDocuments() { (querySnapshot, error) in
            guard let docments = querySnapshot?.documents else { return }
            self.guests = docments.map({ (document) -> Guest in
                return Guest(document: document)
            })
            // 初めて入力画面に入るときと最後のページが使われていないときは白紙のページを1つ追加して白紙ページを表示する
            // ページが使われていない判定は仮で名前が空のとき。
            if self.guests.count == 0 || self.guests.last?.guestName != "" {
                let newGuest = Guest()
                // 配列に加える
                self.guests.append(newGuest)
                // Firestoreに空の情報を登録
                self.createEmptyGuest()
            }
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
    
    // 空のデータをFirestoreに保存する
    fileprivate func createEmptyGuest() {
        print("Create New Page")
        let documentId = self.db.collection("events").document(event.eventId).collection("guests").addDocument(data: ["guestName": "", "eventId": event.eventId, "createdAt": Date(), "updatedAt": Date()])

    }
    
    // 変更されたデータを更新する
    fileprivate func updateGuestData(index: Int) {
        db.collection("events").document(event.eventId).collection("guests").document(guests[index].id).getDocument { (document, error) in
            self.guests[index] = Guest(document: document!)
            if let document = document, document.exists {
                print(document.data()?["guestName"] as! String)
            } else {
                print("Document does not exist")
            }
        }
    }

}
extension GuestsController: UIPageViewControllerDataSource {
    // 左にスワイプ（進む）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("viewControllerAfter")
        let nextIndex = currentIndex + 1
        currentIndex = nextIndex
        if nextIndex <= guests.count - 1 {
            // 変更されたデータを更新する
            self.updateGuestData(index: nextIndex)
            
            return GuestController(guest: guests[nextIndex])
        } else {

            createEmptyGuest()
            db.collection("events").document(event.eventId).collection("guests").addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New guest: \(diff.document.documentID)")
                        self.newGuest = Guest(document: diff.document)
                        self.guests.append(self.newGuest)
                    }
                }
            }
            // 新しいページを作ったときにそのページのDocumentIDがguestsに持たせられていないので、落ちる。
            return GuestController(guest: self.newGuest)
        }
    }
    
    // 右にスワイプ（戻る）
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewControllerBefore")

        let prevIndex = currentIndex - 1
        guard prevIndex >= 0 else { return nil }
        currentIndex = prevIndex
        // 変更されたデータを更新する
        self.updateGuestData(index: prevIndex)
        print(self.guests[prevIndex].guestName)
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
