//
//  GuestDetailTableView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/04/04.
//

import UIKit

protocol ToggleSectionDelegate: AnyObject {
    func sectionHeaderDidTap(_ section: Int)
}

class GuestDetailTableView: UITableView {
    
    var guests: [Guest]
    fileprivate var openedSections = Set<Int>()
    weak var toggleSectionDelegate: ToggleSectionDelegate?
    
    init(guests:[Guest], frame: CGRect, style: UITableView.Style) {
        self.guests = guests
        super.init(frame: .zero, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if openedSections.contains(section) {
                openedSections.remove(section)
            } else {
                openedSections.insert(section)
            }
            toggleSectionDelegate?.sectionHeaderDidTap(section)
        }
    }
}

// MARK:- Extensions
extension GuestDetailTableView: UITableViewDelegate {
    
}

extension GuestDetailTableView: UITableViewDataSource {
    
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
        return 70 * 6 // １項目あたり70の高さを6項目分
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return guests.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let guest = guests[section]
        return "\(guest.pageNumber). \(guest.guestName)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.tag = section
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
        view.addGestureRecognizer(gesture)
        return view
    }
}
