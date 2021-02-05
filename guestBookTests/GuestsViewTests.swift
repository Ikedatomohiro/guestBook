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
    lazy var guestsVC = GuestsController(event, retuals, guests)
    
    func testSetIndex() {
        guestsVC.setIndex(targettIndex: 1, transitionAfter: true)
        XCTAssertEqual(guestsVC.prevIndex, 1)
        XCTAssertEqual(guestsVC.nextIndex, 2)
        
        guestsVC.setIndex(targettIndex: 1, transitionAfter: false)
        XCTAssertEqual(guestsVC.prevIndex, 1)
        XCTAssertEqual(guestsVC.nextIndex, 0)
    }


}
