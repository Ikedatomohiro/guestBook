//
//  SelectGroupView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

protocol SendGroupDataDelegate: AnyObject {
    func sendGroupData(groupCollectionView: GroupCollectionView)
}

class SelectGroupView: UIView {
    fileprivate let groupAskLabel = UILabel()
    var guest: Guest
    var groups: [Group]
    var groupCollectionView: GroupCollectionView
    weak var guestItemUpdateDelegate: GuestItemUpdateDelegate?

    init(_ guest: Guest, _ groups: [Group], _ groupCollectionView: GroupCollectionView ,frame: CGRect) {
        self.guest = guest
        self.groups = groups
        self.groupCollectionView = groupCollectionView
        super.init(frame: frame)
        setupView(groupCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ groupCollectionView: GroupCollectionView) {
        setupGroupAskLabel()
        setupGoupCollectionView(groupCollectionView)
    }
    
    fileprivate func setupGroupAskLabel() {
        addSubview(groupAskLabel)
        groupAskLabel.text = """
        どのような
        ご関係ですか
        """
        groupAskLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 150, height: 80))
        groupAskLabel.font = .systemFont(ofSize: 24)
        groupAskLabel.numberOfLines = 0
    }
    
    fileprivate func setupGoupCollectionView(_ groupCollectionView: GroupCollectionView) {
        addSubview(groupCollectionView)
        groupCollectionView.anchor(top: layoutMarginsGuide.topAnchor, leading: groupAskLabel.trailingAnchor, bottom: groupAskLabel.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        groupCollectionView.backgroundColor = .white
        groupCollectionView.sendGroupDataDelegate = self
    }
}

//MARK:- Extensions
extension SelectGroupView: SendGroupDataDelegate {
    func sendGroupData(groupCollectionView: GroupCollectionView) {
        guestItemUpdateDelegate?.update(inputView: groupCollectionView)
    }
}
