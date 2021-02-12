//
//  GuestListTableView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/01.
//

import UIKit
import FirebaseFirestore

protocol TransitionGuestDetailDelegate: AnyObject {
    func transition(_ guestDetailVC: UIViewController,_ index: Int)
}

class GuestListTableView: UITableView {
    fileprivate let guests: [Guest]
    let retuals: [Retual]
    weak var transitionDelegate: TransitionGuestDetailDelegate?

    init(guests: [Guest], retuals: [Retual], frame: CGRect, style: UITableView.Style) {
        self.guests = guests
        self.retuals = retuals
        super.init(frame: .zero, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GuestListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let guestDetailVC = GuestDetailViewController(guest: guests[indexPath.row])
        guestDetailVC.modalPresentationStyle = .fullScreen
        // GuestListViewContollerに返して、画面遷移させるための情報を提供する
        transitionDelegate?.transition(guestDetailVC, indexPath.row)
    }
}

extension GuestListTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuestCell.className) as? GuestCell else { fatalError("improper UITableViewCell")}
        cell.setupGuestData(guests[indexPath.row], retuals)
        cell.selectionStyle = .none
        return cell
    }
    
    // リスト高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    // ヘッダー
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let guestListHeader = GuestListHeaderCell()
        guestListHeader.backgroundColor = .yellow
        return guestListHeader
    }
    // ヘッダー高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

}
