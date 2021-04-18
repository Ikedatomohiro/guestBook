//
//  GuestListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/21.
//

import UIKit
import FirebaseFirestore

class GuestListViewController: UIViewController {
    
    fileprivate let event: Event
    fileprivate var guests: [Guest]
    fileprivate var retuals: [Retual]
    lazy var guestListTableView = GuestListTableView(guests: guests, retuals: retuals, frame: .zero, style: .plain)
    lazy var guestSortAreaView = GuestSortAreaView(retuals, frame: .zero)
    fileprivate var pageNumber: Int = 1
    var selectRetualId: String = ""
    var selectRank: Dictionary<String, Bool?> = [:]
    let selectGuests = SelectGuests()
    var listener: ListenerRegistration?
    
    var csvOutputButton = UIButton()
    
    init(_ event: Event, _ retuals: [Retual], _ guests: [Guest]) {
        self.event = event
        self.retuals = retuals
        self.guests = guests
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setSortArea(retuals: retuals)
        setupCsvOutputButton()
        setupGuestListTableView()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let _ =  self.navigationController?.viewControllers.last as? GuestEditViewController else {
                listener?.remove()
            return
        }
    }
    
    fileprivate func fetchData() {
        selectGuests.fetchData(eventId: event.eventId) { (guests) in
            let guestsListener = self.selectGuests.collectionRef(self.event.eventId).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else { return }
                self.guests = documents.map{Guest(document: $0)}
                 // GuestListTableView内でリロード
                self.guestListTableView.reloadGuestsData(guests: self.guests)
            }
            self.listener = guestsListener
        }
    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
        // 戻るボタンの名称をセット
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "参加者一覧に戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem

    }
    
    fileprivate func setSortArea(retuals: [Retual]) {
        view.addSubview(guestSortAreaView)
        guestSortAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: .zero, height: screenSize.height / 10))
        guestSortAreaView.sendRetualDelegate = self
    }
    
    fileprivate func setupGuestListTableView() {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: guestSortAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        guestListTableView.transitionDelegate = self
        guestListTableView.changeGuestsRankDelegate = self
        // TableViewをセット
        guestListTableView.register(GuestCell.self, forCellReuseIdentifier: GuestCell.className)
        guestListTableView.separatorStyle = .none
        // 下にスワイプで再読み込み
        guestListTableView.refreshControl = UIRefreshControl()
        guestListTableView.refreshControl?.addTarget(self, action: #selector(pullDownTableView), for: .valueChanged)
    }
    
    @objc func pullDownTableView() {
        self.selectGuests.fetchData(eventId: self.event.eventId) { (guests) in
            self.guests = guests
            self.guestListTableView.reloadGuestsData(guests: guests)
            self.guestListTableView.refreshControl?.endRefreshing()
            self.guestSortAreaView.resetGuestSortPickerview()
        }
    }
    
    fileprivate func setupCsvOutputButton() {
        view.addSubview(csvOutputButton)
        csvOutputButton.setTitle("CSVファイル作成", for: .normal)
        csvOutputButton.anchor(top: guestSortAreaView.topAnchor, leading: nil, bottom: guestSortAreaView.bottomAnchor, trailing: guestSortAreaView.trailingAnchor, size: .init(width: 150, height: 40))
        csvOutputButton.addTarget(self, action: #selector(tapCsvOutputButton), for: .touchUpInside)
        csvOutputButton.backgroundColor = green
        csvOutputButton.layer.cornerRadius = 5
    }
    
    @objc func tapCsvOutputButton() {
        animateView(csvOutputButton)
        csvOutput()
    }
    
    func csvOutput() {
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let path = dirURL.appendingPathComponent("\(event.eventName).csv")
        let csvList = CsvList()
        let data: Data? = csvList.outputGuestList(guests, retuals)
        guard let textFile = data else { return }
        do {
            try textFile.write(to: path)
            aLartCsvOutput(title: "CSVファイル出力", message: "ファイルアプリにCSVファイルを作成しました。")
        } catch {
            print("CSVファイル出力失敗")
        }
    }
    
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
                
            }, completion: nil)
        }
    }
    
    fileprivate func aLartCsvOutput(title: String, message: String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
        print("CSVファイル出力成功")
    }
    
}

// MARK: - Extensions
extension GuestListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.guestListTableView.reloadData()
    }
}

extension GuestListViewController: TransitionGuestDetailDelegate {
    func sendTransitionIndex(_ guests: [Guest], _ index: Int) {
        let guestEditVC = GuestEditViewController(guests: guests, index: index)
        guestEditVC.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(guestEditVC, animated: true)
    }
}

extension GuestListViewController: SendRetualDelegate {
    func selectGuestsByRetual(retual: Retual) {
        // リスト番号リセット
        self.pageNumber = 1
        if retual.id != "" {
            firestoreQueue.async {
                self.selectGuests.selectGuestsFromRetual(eventId: self.event.eventId, retualId: retual.id) { (guests) in
                    DispatchQueue.main.async {
                        // TabeleViewにguestsを渡す
                        print("guest:\(guests.count)")
                        self.guestListTableView.reloadGuestsData(guests: guests)
                    }
                }
            }
        } else {
            firestoreQueue.async {
                self.selectGuests.selectGuestAll(eventId: self.event.eventId) { (guests) in
                    DispatchQueue.main.async {
                        // TabeleViewにguestsを渡す
                        print("guest:\(guests.count)")
                        self.guestListTableView.reloadGuestsData(guests: guests)
                    }
                }
            }
        }
    }
}

extension GuestListViewController: ChangeGuestsRankDelegate {
    func changeGuestsRank(guests: [Guest], selectRank: Dictionary<String, Bool?>) {
        self.selectRank = selectRank
        let selectGuests = SelectGuests()
        var guests_temp = guests
        self.guests = selectGuests.sortGuests(guests: &guests_temp, selectRank: selectRank)
        // TabeleViewにguestsを渡す
        self.guestListTableView.reloadGuestsData(guests: guests_temp)
    }
}
