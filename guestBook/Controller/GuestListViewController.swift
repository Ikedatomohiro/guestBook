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
    lazy var guestSortAreaView: UIView = GuestSortAreaView(retuals, frame: .zero)
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
        setBackButtonTitle()
    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
    }
    
    fileprivate func setSortArea(retuals: [Retual]) {
        view.addSubview(guestSortAreaView)
        
        guestSortAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 10))
        
        

        
    }
    
    
    
    fileprivate func setupGuestListTableView() {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: guestSortAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
        guestListTableView.transitionDelegate = self
        guestListTableView.register(GuestCell.self, forCellReuseIdentifier: GuestCell.className)
        
    }
    
    // 戻るボタンの名称をセット
    fileprivate func setBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "参加者一覧に戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

// MARK: - Extensions
extension GuestListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.guestListTableView.reloadData()
    }
}

extension GuestListViewController: TransitionGuestDetailDelegate {
    func transition(_ guestDetailVC: UIViewController, _ index: Int) {
        let guestDetailVC = GuestDetailViewController(guest: guests[index])
        guestDetailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestDetailVC, animated: true)
    }
}

extension GuestListViewController: SendRetualDelegate {
    func sendRetual(retual: Retual) {
        
    }
}
