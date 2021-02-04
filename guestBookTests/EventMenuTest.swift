//
//  EventMenuTest.swift
//  guestBookTests
//
//  Created by Tomohiro Ikeda on 2021/02/04.
//

import XCTest
@testable import guestBook
class EventMenuTest: XCTestCase {

    let eventMenuVC = EventListViewController()
    let eventId     = TestKeys.eventId

    func testFetchData() {
        
        XCTAssertTrue(eventMenuVC.fetchData())

        
    }







}
