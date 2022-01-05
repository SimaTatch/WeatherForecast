//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import XCTest
@testable import WeatherBrick

class WeatherBrickTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testExample() {
        let apiRequest = APIRequest()
        apiRequest.makeRequest(lat: lat, lon: lon) { response in
            XCTAssertNotNil(response)
        } failure: { error in
            XCTAssertThrowsError("fail: \(error)")
        }
    }
}
