//
//  CreateChallengeViewModel.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 24.08.2023.
//

import Foundation
import RealmSwift


enum StreakDurations: String, CaseIterable {
    case days7 = "7 days"
    case days21 = "21 days"
    
    var days: Int {
        switch self {
        case .days7: return 7
        case .days21: return 21
        }
    }
    
    
}

enum CounterDuration: Int {
    case days10 = 10
    case days30 = 30
    case days60 = 60
    case days365 = 365
}


struct CreateChallengeViewModel {
    
    let realm = try! Realm()

    let streakDurations = ["7 days": 7,
                           "21 days": 21]
    
    let counterDurations = ["10 days": 10,
                            "30 days": 30,
                            "60 days": 60,
                            "365 days": 365]
    
    init(){
        
    }
    
    // MARK: - CRUD for Challenges
    

    func createNewChallenge(title: String, type: ChallengeType, duration: Int, goal: Int?, goalDirection: GoalSign? ){
        
        let newChallenge = Challenge()
        newChallenge.title = title
        newChallenge.type = type
            
        if type == ChallengeType.counter {
            
            if let goal = goal, let goalDirection = goalDirection {
                newChallenge.goal = goal
                newChallenge.counterGoalDirection = goalDirection
                
            } else {
                print("ERROR: Theare not enough parameters to create Counter Challenge!")
            }
        }
        
        newChallenge.duration = duration
        print("Creating new challenge: \(newChallenge)")
            
        do {
            try realm.write{
                realm.add(newChallenge)
            }
            
        } catch {
            print("Error creating Challenge: \(error)")
        }
            
    }
    
    
    func getDurationTitlesFor(type: ChallengeType) -> [String] {
        
        switch type {
        case .streak:
//            return streakDurations.keys.sorted()
            return StreakDurations.allCases.map({ $0.rawValue })
        case .counter:
            return counterDurations.keys.sorted()
        }
    }
    
    
    func getDurationFor(type: ChallengeType, title: String ) -> Int {
        
        guard let duration = (type == .streak) ?
//                streakDurations[title] :
                StreakDurations.allCases.first(where: { $0.rawValue == title })?.days :
                counterDurations[title] else {
            fatalError("There are duaration title that not in durations list! \(title)")
        }
        
        return duration
        
    }
}

