//
//  ChallengeModel.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 21.02.2023.
//

import Foundation
import RealmSwift

let realm = try! Realm()

enum ChallengeType: String, PersistableEnum {
    case streak
    case counter
}

enum GoalSign: String, PersistableEnum {
    case moreThan = ">="
    case lessThan = "<="
}

class Challenge: Object {
    
       
    @Persisted var title: String
    @Persisted var startDate: Date
    @Persisted var checkedDates: List<Date>

    @Persisted var count: Int = 0
    @Persisted var goal: Int = 0
    @Persisted var todayCheck: Bool = false 
    @Persisted var type: ChallengeType
    
    @Persisted var counterGoalDirection: GoalSign
    
    var streak: Int {
        if self.checkedDates.count == 0 {
            return 0
        }
        else {
            if let lastCheckedDay = self.checkedDates.last {
                if let daysCount = Calendar.current.dateComponents([.day], from: lastCheckedDay, to: Date()).day {
                    if daysCount > 1 {
                        return 0
                    } else {
                        print("STREAK = \(getLastStreak())")
    //                    return Calendar.current.dateComponents([.day], from: checkedDates[checkedDates.count-2], to: Date()).day ?? 0
                        return getLastStreak()
                    }
                    
                }
                
                    
            }
        }
        
        return 0
    }
    
    var progress: Float {
        if goal == 0 {
            return 0
        }
        return Float(streak)/Float(goal)
    }

    func getLastStreak() -> Int {
        
        var counter = 0
        let datesCount = checkedDates.count
        
        var fromDate = Date()
        var toDate = Date()
//        print("datesCount = \(datesCount)")
        for n in 1...datesCount {
            
//            print("n = \(n)")
//            print("fromDate = \(fromDate)")
//            print("toDate = \(toDate)")
            fromDate = checkedDates[datesCount-n]
            
            let dist = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day
//            print("Distance = \(dist)")
            if dist == 0 || dist == 1 {
                toDate = fromDate
                fromDate = checkedDates[datesCount - n]
                counter += 1
//                print("It is b2b day: \(counter)")
            } 
            else {
                return counter
            }
            
        }
        
        return counter
    }
    
    override init() {
        startDate = Date()
        
    }
    
}
