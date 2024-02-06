//
//  ChallengeViewModelTests.swift
//  ChallengeAcceptedTests
//
//  Created by Svetlana Kirillova on 28.08.2023.
//

import XCTest
import RealmSwift

@testable import ChallengeAccepted

final class ChallengeViewModelTests: XCTestCase {

    // MARK: - setup & tearDown
    
    override func setUpWithError() throws {

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name

        let realm = try! Realm()
    }

    override func tearDownWithError() throws {
        
    }

    // MARK: - Tests for Streak
    
    func testStreak(){
//        let challenge = Challenge(
//        let viewModel = ChallengeViewModel(challenge: <#T##Challenge#>)
    }
}
