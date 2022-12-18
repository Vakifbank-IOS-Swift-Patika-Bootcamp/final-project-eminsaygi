//
//  GameListViewModelUnitTest.swift
//  GameZoneTests
//
//  Created by Emin Saygı on 18.12.2022.
//

import XCTest

class GameListViewModelTests: XCTestCase {
    
    var sut: GameListViewModel!
    var testGames: [Game]!
    
    override func setUp() {
        super.setUp()
        
        testGames = [Game(name: "Game 1", rating: 9.0, released: "2020-01-01", background_image: "image1.png"),                     Game(name: "Game 2", rating: 8.5, released: "2020-02-01", background_image: "image2.png"),                     Game(name: "Game 3", rating: 7.0, released: "2020-03-01", background_image: "image3.png")]
        
        sut = GameListViewModel(results: testGames)
    }
    
    override func tearDown() {
        sut = nil
        testGames = nil
        
        super.tearDown()
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(sut.numberOfSections, testGames.count)
    }
    
    func testNumberOfRowsInSection() {
        for i in 0..<testGames.count {
            XCTAssertEqual(sut.numberOfRowsInSeciton(i), testGames.count)
        }
    }
    
    func testGameAtIndex() {
        for i in 0..<testGames.count {
            let gameViewModel = sut.gameAtIndex(i)
            XCTAssertEqual(gameViewModel.name, testGames[i].name)
            XCTAssertEqual(gameViewModel.rating, testGames[i].rating)
            XCTAssertEqual(gameViewModel.released, testGames[i].released)
            XCTAssertEqual(gameViewModel.background_image, testGames[i].background_image)
        }
    }
}

class GameViewModelTests: XCTestCase {
    
    var sut: GameViewModel!
    var testGame: Game!
    
    override func setUp() {
        super.setUp()
        
        testGame = Game(name: "Test Game", rating: 9.5, released: "2022-01-01", background_image: "test_image.png")
        sut = GameViewModel(testGame)
    }
    
    override func tearDown() {
        sut = nil
        testGame = nil
        
        super.tearDown()
    }
    
    func testProperties() {
        XCTAssertEqual(sut.name, testGame.name)
        XCTAssertEqual(sut.rating, testGame.rating)
        XCTAssertEqual(sut.released, testGame.released)
        XCTAssertEqual(sut.background_image, testGame.background_image)
    }
}
