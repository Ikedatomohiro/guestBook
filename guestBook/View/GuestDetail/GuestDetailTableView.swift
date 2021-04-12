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
    var section: Int
    weak var toggleSectionDelegate: ToggleSectionDelegate?
    var updateGuestParam: Array<String> = []
    
    init(guests:[Guest], index: Int, frame: CGRect, style: UITableView.Style) {
        self.guests = guests
        self.section = index
        super.init(frame: .zero, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // タップしたセクションを開き、前に開いていたセクションを閉じる
    func selectAndUpdateGuest(section: Int) {
        let guest = guests[self.section]
        let beforeSection = self.section
        let afterSection = section
        self.section = section
        performBatchUpdates {
            deleteRows(at: [IndexPath(row: 0, section: beforeSection)], with: .fade)
            insertRows(at: [IndexPath(row: 0, section: afterSection)], with: .fade)
        } completion: { (_) in
            
        }
        // guestの変更があったときに更新する
        if updateGuestParam.count == 0 { return }
        Guest.updateGuest(guest, guest.eventId, nil)
    }
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            toggleSectionDelegate?.sectionHeaderDidTap(section)
        }
    }
}

// MARK:- Extensions
extension GuestDetailTableView: UITableViewDelegate {
    
}

extension GuestDetailTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.section == section {
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
        cell.guestDetailUpdateDelegate = self
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
        return "\(section + 1). \(guest.guestName)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.tag = section
        if section % 2 == 0 {
            view.contentView.backgroundColor = .white
        } else {
            view.contentView.backgroundColor = lightGreent
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
        view.addGestureRecognizer(gesture)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension GuestDetailTableView: GuestDetailUpdateDelegate {
    func update<T>(inputView: T, index: Int) {
        if let textField: UITextField = inputView as? UITextField {
            var guest = guests[index]
            let identifire = textField.accessibilityIdentifier
            switch identifire {
            case "guestName":
                guest.guestName = textField.text ?? ""
                break
            case "companyName":
                guest.companyName = textField.text ?? ""
                break
            case "zipCode":
                guest.zipCode = textField.text ?? ""
                break
            case "address":
                guest.address = textField.text ?? ""
                break
            case "telNumber":
                guest.telNumber = textField.text ?? ""
               break
            case "description":
                guest.description = textField.text ?? ""
               break
            default:
                break
            }
            updateGuestParam.append(identifire ?? "")
            guests[index] = guest
        }
    }
}
