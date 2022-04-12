//
//  CatsTests.swift
//  CatsTests
//
//  Created by Mark Khmelnitskii on 12.04.2022.
//

import XCTest
import Combine
@testable import Cats

class CatsTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        bag = []
    }
    
    var bag = Set<AnyCancellable>()
    
    func testGetAllCats() {
        let expectation = expectation(description: "error mes")
        API.getAllCats(page: 0, limit: 50).sink {
            switch $0 {
            case .finished:
                break
            case .failure(_):
                expectation.fulfill()
            }
        } receiveValue: {
            if $0.isEmpty {
                XCTFail()
            }
            expectation.fulfill()
        }.store(in: &bag)
        wait(for: [expectation], timeout: 5)
    }
    
}
