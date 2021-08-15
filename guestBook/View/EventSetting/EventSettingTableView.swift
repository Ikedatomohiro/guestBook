//
//  EventSettingTableView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/08/12.
//

import UIKit

class EventSettingTableView: UITableView {
    
    weak var eventSettingDelegate: EventSettingDelegate?
    var event: Event
    enum EventSettingItem: String {
        case eventName    = "儀式名"
        case deceasedName = "故人のお名前"
        case chiefMourner = "喪主"
        case eventDate    = "開催日"
        case eventPlace   = "会場名"
        case description  = "その他情報"
        
        static let items: [EventSettingItem] = [.eventName, .deceasedName, .chiefMourner, .eventDate, .eventPlace, .description]
    }
    
    init(event: Event, frame: CGRect, style: UITableView.Style) {
        self.event = event
        super.init(frame: .zero, style: style)
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- Extentions
extension EventSettingTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventSettingItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventSettingTableViewCell.className) as? EventSettingTableViewCell else { fatalError("improper UITableViewCell")}
        let item = EventSettingItem.items[indexPath.row]
        cell.setupEventSettingTableViewCell(event: event, item: item, indexPath: indexPath.row)
        cell.selectionStyle = .none
        cell.eventSettingDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 項目によって返す値を変える
        let item = EventSettingItem.items[indexPath.row]
        var height = screenSize.height / 12
        if item.self == .description {
            height = screenSize.height - height * CGFloat(EventSettingItem.items.count)
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EventSettingHeaderFotterView()
        headerView.setup()
        return headerView
    }
    
    // ヘッダー高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension EventSettingTableView: UITableViewDelegate {
    
}

extension EventSettingTableView: EventSettingDelegate {
    func sendTextToTable<T>(inputView: T) {
        eventSettingDelegate?.sendTextToController(inputView: inputView)
    }
}
