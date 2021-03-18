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
    fileprivate let stackView = UIStackView()

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
        guestsTable.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 4, height: .zero))
        guestsTable.delegate = self
        guestsTable.dataSource = self
        guestsTable.register(TextCell.self, forCellReuseIdentifier: TextCell.className)
    }
    
    fileprivate func setupGuestsDetailPageView() {
//        addChild(guestsDetailPageViewController)
        view.addSubview(guestsDetailPageViewController.view)
//        stackView.addArrangedSubview()
        guestsDetailPageViewController.view.anchor(top: view.layoutMarginsGuide.topAnchor, leading: guestsTable.trailingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor)
    }
}

// MARK:- Extensions
extension GuestEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.className) as? TextCell  else {
            fatalError("improper UITableViewCell")}
        cell.setText(text: guests[indexPath.row].guestName)
        return cell
    }
    
    
}

extension GuestEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップしました。")
    }
}
