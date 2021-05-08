//
//  SideMenuView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/03.
//

import UIKit

protocol SideMenuItemDidTapDelegate: AnyObject {
    func sideMenuItemDidTap(sideMenuItem: SideMenuListView.SideMenuItem)
}

class SideMenuListView: UIView {
    
    enum SideMenuItem: String {
        case setting = "設定"
        case privacyPolicy = "プライバシーポリシー"
        case termsOfUse = "利用規約"
        case signOut = "サインアウト"
        
        static let items: [SideMenuItem] = [.setting, .privacyPolicy, .termsOfUse, .signOut]
        
        var viewController: UIViewController? {
            switch self {
            case .setting: return SettingViewController()
            case .privacyPolicy: return PrivacyPolicyViewController()
            case .termsOfUse: return TermsOfUseViewController()
            case .signOut: return nil
            }
        }
    }
    
    let sideMenuTable = UITableView()
    weak var sideMenuItemDidTapDelegate: SideMenuItemDidTapDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSideMenuTable()
        sideMenuTable.dataSource = self
        sideMenuTable.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSideMenuTable() {
        addSubview(sideMenuTable)
        // cellが空欄のデータを表示しないようにする（Footerにからのデータがあるとcellが空欄のデータが表示されなくなる）
        sideMenuTable.tableFooterView = UIView(frame: .zero)
        sideMenuTable.fillSuperview(padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
}

extension SideMenuListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuItem.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SideMenuTableViewCell()
        //        cell.setupSideMenuCell(text: SideMenuItem.items[indexPath.row].headline)
        cell.textLabel?.text = SideMenuItem.items[indexPath.row].rawValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height / 15
    }
    
}

extension SideMenuListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sideMenuItemDidTapDelegate?.sideMenuItemDidTap(sideMenuItem: SideMenuItem.items[indexPath.row])
    }
}
