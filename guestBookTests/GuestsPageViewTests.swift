//
//  GuestsPageViewTests.swift
//  guestBookTests
//
//  Created by Tomohiro Ikeda on 2021/02/04.
//

import XCTest
@testable import guestBook

class GuestsPageViewTests: XCTestCase {
    
    let event = Event()
    let retuals = [Retual(name: "kankonsousai")]
    lazy var guests = [Guest("new", retuals)]
    lazy var guestsVC = GuestsPageViewController(event, retuals, guests)
    
    func testSetIndex() {
        guestsVC.setIndex(1, viewControllerAfter: true)
        XCTAssertEqual(guestsVC.prevIndex, 1)
        XCTAssertEqual(guestsVC.nextIndex, 2)
        XCTAssertEqual(guestsVC.currentIndex, 2)
        
        guestsVC.setIndex(1, viewControllerAfter: false)
        XCTAssertEqual(guestsVC.prevIndex, 1)
        XCTAssertEqual(guestsVC.nextIndex, 0)
        XCTAssertEqual(guestsVC.currentIndex, 0)
    }
    
    
}
