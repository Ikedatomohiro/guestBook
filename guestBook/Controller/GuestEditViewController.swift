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
    fileprivate let guestsTable: UITableView = UITableView()
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
        view.addSubview(guestsTable)
        guestsTable.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 4, height: .zero))
        guestsTable.delegate = self
        guestsTable.dataSource = self
        guestsTable.register(GuestDetailViewCell.self, forCellReuseIdentifier: GuestDetailViewCell.className)
        guestsTable.separatorStyle = .none
        openedSections.insert(index)
    }
    
    fileprivate func setupGuestsDetailPageView() {
        view.addSubview(guestsDetailPageViewController.view)
        guestsDetailPageViewController.view.anchor(top: view.layoutMarginsGuide.topAnchor, leading: guestsTable.trailingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if openedSections.contains(section) {
                openedSections.remove(section)
            } else {
                openedSections.insert(section)
            }
            guestsTable.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }
}

// MARK:- Extensions
extension GuestEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections.contains(section) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuestDetailViewCell.className) as? GuestDetailViewCell  else {
            fatalError("improper UITableViewCell")}
        cell.setupCell(guests[indexPath.section], index: indexPath.section)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return guests.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let guest = guests[section]
        return "\(guest.pageNumber): \(guest.guestName)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.tag = section
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
        view.addGestureRecognizer(gesture)
        view.tag = section
        return view
    }
}

extension GuestEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップしました。")
    }
    
}
