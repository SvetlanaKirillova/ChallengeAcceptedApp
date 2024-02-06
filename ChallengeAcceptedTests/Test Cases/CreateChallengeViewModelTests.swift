//
//  CreateChallengeViewModelTests.swift
//  ChallengeAcceptedTests
//
//  Created by Svetlana Kirillova on 28.08.2023.
//

import XCTest
@testable import ChallengeAccepted
import RealmSwift

final class CreateChallengeViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {

    }

    
    func testGetDurationTitlesFor_StreakType(){
        let createChallengeViewModel = CreateChallengeViewModel()
        let results = StreakDurations.allCases.map({ $0.rawValue })
        XCTAssertEqual(createChallengeViewModel.getDurationTitlesFor(type: .streak), results)
    }

    
    func testGetDurationTitlesFor_CounterType(){
        let createChallengeViewModel = CreateChallengeViewModel()
        let results = createChallengeViewModel.counterDurations.keys.sorted()
        XCTAssertEqual(createChallengeViewModel.getDurationTitlesFor(type: .counter), results)
    }
    
    func testGetDurationFor_StreakChallenge(){
        let createChallengeViewModel = CreateChallengeViewModel()
        let result = createChallengeViewModel.getDurationFor(type: .streak, title: "7 days" )
        XCTAssertEqual(result, 7)
    }
    
    func testGetDurationFor_CounterChallenge(){
        let createChallengeViewModel = CreateChallengeViewModel()
        let result = createChallengeViewModel.getDurationFor(type: .counter, title: "30 days" )
        XCTAssertEqual(result, 30)
    }
    
    func testCreateStreakChallenge(){
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()
        var resBefore = realm.objects(Challenge.self).count
        
        let createChallengeViewModel = CreateChallengeViewModel()

        createChallengeViewModel.createStreakChallenge(title: "Test Streak Challenge", duration: 35)
        var resAfter = realm.objects(Challenge.self).count
        
        XCTAssertEqual(resBefore+1, resAfter)
    }
    
    func testCreateNewChallenge_Counter(){
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()
        var resBefore = realm.objects(Challenge.self).count
        
        let createChallengeViewModel = CreateChallengeViewModel()

        createChallengeViewModel.createCounterChallenge(title: "Test Counter Challenge", duration: 14, goal: 10, goalDirection: .lessThan)
        var resAfter = realm.objects(Challenge.self).count
        
        XCTAssertEqual(resBefore+1, resAfter)
    }
}
