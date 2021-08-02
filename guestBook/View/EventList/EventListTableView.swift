//
//  EventListTableView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/23.
//

import UIKit

protocol EventListTableViewDelegate: AnyObject {
    func didSelectEvent(event: Event)
}

class EventListTableView: UITableView {
    fileprivate var events: [Event]
    weak var eventListTableViewDelegate: EventListTableViewDelegate?
    
    init(events: [Event], frame: CGRect, style: UITableView.Style) {
        self.events = events
        super.init(frame: .zero, style: style)
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadEventListData(events: [Event]) {
        self.events = events
        reloadData()
    }
}

// MARK:- Extensions
extension EventListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventListTableViewDelegate?.didSelectEvent(event: events[indexPath.row])
    }
}

extension EventListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventListCell.className) as? EventListCell else { fatalError("improper UITableViewCell")}
        cell.setupEventCell(events[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    // ヘッダー
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let eventListHeader = EventListHeaderFooterView()
        eventListHeader.setup()
        return eventListHeader
    }
    // ヘッダー高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
