//
//  EventListTest.swift
//  guestBookTests
//
//  Created by Tomohiro Ikeda on 2021/02/03.
//

import XCTest

@testable import guestBook
class EventListTest: XCTestCase {

    let eventViewController = EventListViewController()
    let eventNameTableView  = EventListViewController().eventNameTableView
    
    func testSetupTitleLabel() {
        XCTAssertEqual(eventViewController.titleLabel.text, nil)
        eventViewController.viewDidLoad()
        XCTAssertEqual(eventViewController.titleLabel.text, "芳名帳アプリ")
        XCTAssertNotEqual(eventViewController.titleLabel.text, nil)
    }
    
    func testEventNameTableView() {
        XCTAssertEqual(eventViewController.numberOfSections(in: eventNameTableView), 1)

    }
    

}
