import XCTest

final class GamDetailTest: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
     
    }

    func testGetDetailData() {
        let expectation = XCTestExpectation(description: "Get game detail data")
        
        let gameDetailVC = GameDetailVC()
        gameDetailVC.selectedId = 123
        
        gameDetailVC.getDetailData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let label = gameDetailVC.titleLabel {
                XCTAssertEqual(label.text, "Game Title")
            }

            if let label = gameDetailVC.releaseLabel {
                XCTAssertEqual(label.text, "2022-01-01")
            }

            if let label = gameDetailVC.overViewLabel {
                XCTAssertEqual(label.text, "This is a description of the game.")
            }

            if let label = gameDetailVC.voteAverageLabel {
                XCTAssertEqual(label.text, "8.5/10")
            }

         
            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
