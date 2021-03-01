//
//  GuestListViewTest.swift
//  guestBookTests
//
//  Created by Tomohiro Ikeda on 2021/02/12.
//

import XCTest

@testable import guestBook
class GuestListViewTests: XCTestCase {
    var selectRank: Dictionary<String, Bool?> = ["guestName": nil, "companyName": nil]
    lazy var guestListHeaderCell = GuestListHeaderCell(selectRank: selectRank, style: .default, reuseIdentifier: .none)
    var testButton = UIButton()
    
    
    func testChangeRank() {
        setupTestButton()
        // テスト開始
        guestListHeaderCell.changeRank(sender: testButton)
//        XCTAssertNil(selectRank["guestName"] ?? nil)
//        XCTAssertTrue(selectRank["guestName"] != nil)
        
        
    }
    
    func setupTestButton() {
        testButton.tag = 1
    }
    
}
