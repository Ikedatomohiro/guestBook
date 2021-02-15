//
//  GuestListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/21.
//

import UIKit
import FirebaseFirestore

class GuestListViewController: UIViewController {
    
    fileprivate let event: Event
    fileprivate var guests: [Guest]
    fileprivate var retuals: [Retual]
    lazy var guestListTableView = GuestListTableView(guests: guests, retuals: retuals, frame: .zero, style: .plain)
    lazy var guestSortAreaView = GuestSortAreaView(retuals, frame: .zero)
    fileprivate var pageNumber  : Int     = 1
    
    init(_ event: Event, _ retuals: [Retual], _ guests: [Guest]) {
        self.event = event
        self.retuals = retuals
        self.guests = guests
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setSortArea(retuals: retuals)
        setupGuestListTableView()
    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
        // 戻るボタンの名称をセット
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "参加者一覧に戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem}
    
    fileprivate func setSortArea(retuals: [Retual]) {
        view.addSubview(guestSortAreaView)
        
        guestSortAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 10))
        
        guestSortAreaView.sendRetualDelegate = self
        
        
    }
    
    fileprivate func setupGuestListTableView() {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: guestSortAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        guestListTableView.transitionDelegate = self
        guestListTableView.register(GuestCell.self, forCellReuseIdentifier: GuestCell.className)
    }
}

// MARK: - Extensions
extension GuestListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.guestListTableView.reloadData()
    }
}

extension GuestListViewController: TransitionGuestDetailDelegate {
    func sendTransitionIndex(_ guestDetailVC: UIViewController, _ index: Int) {
        let guestDetailVC = GuestDetailViewController(guest: guests[index])
        guestDetailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestDetailVC, animated: true)
    }
}

extension GuestListViewController: SendRetualDelegate {
    func sendRetual(retual: Retual) {
        // 得られた情報からデータを検索
        Guest.collectionRef(event.eventId).whereField("retuals.\(retual.id)", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    var guest = Guest(document: document)
                    guest.pageNumber = self.pageNumber
                    self.pageNumber += 1
                    return guest
                })
            } else {
                print("取得に失敗しました。")
                print(error as Any)
                return
            }
        }
        
        
        
        
        
        
        
        // TabeleViewにguestsを渡す
        
        
        
        
    }
    
    
}
