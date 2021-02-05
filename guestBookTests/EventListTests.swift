//
//  EventListTests.swift
//  guestBookTests
//
//  Created by Tomohiro Ikeda on 2021/02/03.
//

import XCTest

@testable import guestBook
class EventListTests: XCTestCase {

    let eventListVC = EventListViewController()
    let eventNameTableView  = EventListViewController().eventNameTableView
    
    func testSetupTitleLabel() {
        XCTAssertEqual(eventListVC.titleLabel.text, nil)
        eventListVC.viewDidLoad()
        XCTAssertEqual(eventListVC.titleLabel.text, "芳名帳アプリ")
        XCTAssertNotEqual(eventListVC.titleLabel.text, nil)
    }
    
    func testEventNameTableView() {
        XCTAssertEqual(eventListVC.numberOfSections(in: eventNameTableView), 1)

    }
    

}
