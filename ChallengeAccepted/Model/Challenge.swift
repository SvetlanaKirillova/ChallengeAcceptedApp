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
    case moreThan = "minimum"
    case lessThan = "maximum"
}


class Challenge: Object {
       
    @Persisted var title: String
    @Persisted var startDate: Date
    @Persisted var checkedDates: List<Date>

    @Persisted var duration: Int = 0
    @Persisted var goal: Int = 0
    @Persisted var todayCheck: Bool = false 
    @Persisted var type: ChallengeType
    
    @Persisted var counterGoalDirection: GoalSign?
    
    var streak: Int {
        var counter = 0
        let datesCount = checkedDates.count
        
        if datesCount == 0 || datesCount == 1{
            return 0
        }
        
        var fromDate = Date()
        var toDate = Date()

        for dayIndex in 0...datesCount {
            fromDate = checkedDates[datesCount-dayIndex-1]
            
            let dist = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day
            
            if dist == 0 || dist == 1 {
                
                toDate = fromDate
                fromDate = checkedDates[datesCount - dayIndex - 1]
                counter += 1

            }
            else {

                return counter
            }
        }
        return counter
    }
    
    var progress: Float {
        if type == .streak{
            if duration == 0 {
                return 0
            }
            return Float(streak)/Float(duration)
        }
        
        return 0
    }

    
    override init() {

        startDate = Date().onlyDate
        
    }
    
}
