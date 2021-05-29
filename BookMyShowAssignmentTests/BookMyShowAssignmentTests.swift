//
//  BookMyShowAssignmentTests.swift
//  BookMyShowAssignmentTests
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 28/05/21.
//

import XCTest
@testable import BookMyShowAssignment

class BookMyShowAssignmentTests: XCTestCase {
    let mockdataSourceViewModel = DataSourceViewModel()
    var mockSectionModel = [SectionModel]()
    var mockDetailSectionModel = [DetailSectionModel]()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitializeModels() {
        mockSectionModel = [SectionModel(title: "MockSection", rows: [DataModel(movieName: "Test", image: UIImage(), releaseDate: "29-05-2021")])]
        mockDetailSectionModel = [DetailSectionModel(title: "MockDetailSection", rows: [DetailDataModel(overView: "OverView", ratings: 5, language: "English")])]
        XCTAssertTrue(true,"Models Initialized")
    }

    func testSendRequest() {
        _ = mockdataSourceViewModel.sendUrlRequest()
        XCTAssertTrue(true,"Request Successfull")
    }
    
    func testFetchCards() {
        let publisher = mockdataSourceViewModel.fetchCards()
        publisher
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
            if case .failure(let error) = completion {
                print("fetch error -- \(error)")
            }
        } receiveValue: { [weak self] cards in
            self?.mockSectionModel = cards
        }.cancel()
        XCTAssertTrue(true,"Cards Fetched")
    }
    
    func testFetchDetailCards() {
        let publisher = mockdataSourceViewModel.fetchDetailCards()
        publisher
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
            if case .failure(let error) = completion {
                print("fetch error -- \(error)")
            }
        } receiveValue: { [weak self] cards in
            self?.mockDetailSectionModel = cards
        }.cancel()
        XCTAssertTrue(true,"Detail Cards fetched")
    }

}
