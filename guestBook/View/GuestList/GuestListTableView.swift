//
//  GuestListTableView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/01.
//

import UIKit
import FirebaseFirestore

protocol TransitionGuestDetailDelegate: AnyObject {
    func sendTransitionIndex(_ guestDetailVC: UIViewController,_ index: Int)
}

protocol ChangeGuestsRankDelegate: AnyObject {
    func changeGuestsRank(guests: [Guest], selectRank: Dictionary<String, Bool?>)
}

class GuestListTableView: UITableView {
    
    fileprivate var guests: [Guest]
    let retuals: [Retual]
    var selectRank: Dictionary<String, Bool?> = [:]

    weak var transitionDelegate: TransitionGuestDetailDelegate?
    weak var changeGuestsRankDelegate: ChangeGuestsRankDelegate?
    
    init(guests: [Guest], retuals: [Retual], frame: CGRect, style: UITableView.Style) {
        self.guests = guests
        self.retuals = retuals
        super.init(frame: .zero, style: style)
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadGuestsData(guests: [Guest]) {
        self.guests = guests
        reloadData()
    }
    
}

// MARK:- Extensions
extension GuestListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let guestDetailVC = GuestDetailViewController(guests: guests, index: indexPath.row)
        guestDetailVC.modalPresentationStyle = .fullScreen
        // GuestListViewContollerに返して、画面遷移させるための情報を提供する
        transitionDelegate?.sendTransitionIndex(guestDetailVC, indexPath.row)
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
        cell.setupGuestCell(guests[indexPath.row], retuals, indexPath: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    // リスト高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        screenSize.height / 15
    }
    
    // ヘッダー
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let guestListHeader = GuestListHeaderCell(selectRank: selectRank, style: .default, reuseIdentifier: .none)
        guestListHeader.sendGuestRank = self
        return guestListHeader
    }
    
    // ヘッダー高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

}

// MARK:- Extentions
extension GuestListTableView: SentGuestsRankDelegate {
    func sendGuestRank(selectRank: Dictionary<String, Bool?>) {
        self.selectRank = selectRank
        changeGuestsRankDelegate?.changeGuestsRank(guests: guests, selectRank: self.selectRank)
    }
}
