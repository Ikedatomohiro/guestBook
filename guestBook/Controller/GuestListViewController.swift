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
    fileprivate var pageNumber: Int = 1
    var selectRetualId: String = ""
    var selectRank: Dictionary<String, Bool?> = [:]
    
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
        guestListTableView.changeGuestsRankDelegate = self
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
    func selectGuestsByRetual(retual: Retual) {
        // リスト番号リセット
        self.pageNumber = 1
        let selectGuests = SelectGuests()
        if retual.id != "" {
            firestoreQueue.async {
                selectGuests.selectGuestsFromRetual(eventId: self.event.eventId, retualId: retual.id) { (guests) in
                    DispatchQueue.main.async {
                        // TabeleViewにguestsを渡す
                        print("guest:\(guests.count)")
                        self.guestListTableView.reloadGuestsData(guests: guests)
                    }
                }
            }
        } else {
            firestoreQueue.async {
                selectGuests.selectGuestAll(eventId: self.event.eventId) { (guests) in
                    DispatchQueue.main.async {
                        // TabeleViewにguestsを渡す
                        print("guest:\(guests.count)")
                        self.guestListTableView.reloadGuestsData(guests: guests)
                    }
                }
            }
        }
    }
}

extension GuestListViewController: ChangeGuestsRankDelegate {
    func changeGuestsRank(guests: [Guest], selectRank: Dictionary<String, Bool?>) {
        self.selectRank = selectRank
        let selectGuests = SelectGuests()
        var guests_temp = guests
        self.guests = selectGuests.sortGuests(guests: &guests_temp, selectRank: selectRank)
        // TabeleViewにguestsを渡す
        self.guestListTableView.reloadGuestsData(guests: guests_temp)
    }
}
