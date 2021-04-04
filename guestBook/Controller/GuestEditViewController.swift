//
//  GuestEditController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/17.
//

import UIKit

class GuestEditViewController: UIViewController {
    
    fileprivate let guests: [Guest]
    fileprivate var index: Int = 0
    //    fileprivate let guestsDetailTableView: UITableView = UITableView()
    lazy var guestsDetailTableView = GuestDetailTableView(guests: guests, frame: .zero, style: .plain)
    fileprivate var openedSections = Set<Int>()
    fileprivate var currentOpenSectionNumber: Int?
    
    lazy var guestsDetailPageViewController = GuestsDetailPageViewController(guests: guests, index: index)
    
    init(guests: [Guest], index: Int) {
        self.guests = guests
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGuestsList()
        setupGuestsDetailPageView()
    }
    
    fileprivate func setupGuestsList() {
        view.addSubview(guestsDetailTableView)
        guestsDetailTableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 4, height: .zero))
        guestsDetailTableView.register(GuestDetailViewCell.self, forCellReuseIdentifier: GuestDetailViewCell.className)
        guestsDetailTableView.separatorStyle = .none
        guestsDetailTableView.layer.borderWidth = 1.0
        guestsDetailTableView.layer.borderColor = UIColor.gray.cgColor
        guestsDetailTableView.toggleSectionDelegate = self
        openedSections.insert(index)
    }
    
    fileprivate func setupGuestsDetailPageView() {
        view.addSubview(guestsDetailPageViewController.view)
        guestsDetailPageViewController.view.anchor(top: view.topAnchor, leading: guestsDetailTableView.trailingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if openedSections.contains(section) {
                openedSections.remove(section)
            } else {
                openedSections.insert(section)
            }
            guestsDetailTableView.reloadSections(IndexSet(integer: section), with: .fade)
            guestsDetailPageViewController.moveGuestDetailPage(from: 1, to: section)
        }
    }
}

// MARK:- Extensions
extension GuestEditViewController: ToggleSectionDelegate {
    func sectionHeaderDidTap(_ section: Int) {
        guestsDetailTableView.reloadSections(IndexSet(integer: section), with: .fade)
        guestsDetailPageViewController.moveGuestDetailPage(from: 1, to: section)
    }
    
    
}
