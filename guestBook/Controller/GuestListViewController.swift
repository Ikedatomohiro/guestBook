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
    fileprivate var guests = [Guest]()
    fileprivate var guestListTableView = UITableView()
    fileprivate var db = Firestore.firestore()
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchGuestList()
        setupGuestListTableView()
    }

    func fetchGuestList() {
        db.collection("events").document(event.eventId).collection("guests").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
//            self.guests = documents.map{Guest(document: $0)}
            self.guests = documents.map{ (document) -> Guest in
                return Guest(document: document)
            }
            self.guestListTableView.reloadData()
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    fileprivate func setupGuestListTableView() {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        guestListTableView.delegate = self
        guestListTableView.dataSource = self
        guestListTableView.register(GuestCell.self, forCellReuseIdentifier: GuestCell.className)
    }
    
        
        

    
    // MARK: - Table view data source

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension GuestListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("guestName")
    }
}

extension GuestListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuestCell.className) as? GuestCell else { fatalError("improper UITableViewCell")}
        cell.setupGuestData(guest: guests[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }

    
    
}
