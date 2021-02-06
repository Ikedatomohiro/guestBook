//
//  GuestsViewTests.swift
//  guestBookTests
//
//  Created by Tomohiro Ikeda on 2021/02/04.
//

import XCTest
@testable import guestBook

class GuestsViewTests: XCTestCase {
    
    let event = Event()
    let retuals = [Retual(name: "kankonsousai")]
    lazy var guests = [Guest(id: "new", retualList: retuals)]
    lazy var guestsVC = GuestsPageViewController(event, retuals, guests)
    
    func testSetIndex() {
        guestsVC.setIndex(1, viewControllerAfter: true)
        XCTAssertEqual(guestsVC.prevIndex, 1)
        XCTAssertEqual(guestsVC.nextIndex, 2)
        
        guestsVC.setIndex(1, viewControllerAfter: false)
        XCTAssertEqual(guestsVC.prevIndex, 1)
        XCTAssertEqual(guestsVC.nextIndex, 0)
    }
    
    
}
