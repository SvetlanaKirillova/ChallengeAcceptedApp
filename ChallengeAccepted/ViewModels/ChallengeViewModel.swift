//
//  ChallengeViewModel.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 20.08.2023.
//

import Foundation
import RealmSwift


struct ChallengeViewModel {
    
    let realm = try! Realm()

    let challenge: Challenge
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    var title: String {
        return challenge.title
    }
    
    var duration: Int {
        return challenge.duration
    }
    
    var startDate: Date {
        return challenge.startDate
    }
    
    var streakValue: Int {
        return challenge.streak
    }
    
    var progress: Float {
        return challenge.progress
    }
    
    var progressDescription: String {
        if progress < 1 {
            return "To achieve your goal, you need \(Int(duration - streakValue )) more days"

        } else  {
            return "You have reached the goal! Challenge copmleted!"

        }
    }
    
    var counterGoal: Int {
        return challenge.goal
    }
    
    var counterChallengeDirection: GoalSign? {
        return  challenge.counterGoalDirection
    }
    
    var checkedDates: [Date]{
        return Array(challenge.checkedDates)
    }
    
    
    
    
    // MARK: - CRUD for Challenges
    
//    mutating func loadChallenges(){
//
//        challenges = realm.objects(Challenge.self)
//    }
//
    
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
    
    
    func updateCheckedDate(date: Date, isDone: Bool){
        
        do {
            try realm.write({
                
                challenge.todayCheck = isDone
                
                if isDone {
                    challenge.checkedDates.append(date)
                    challenge.checkedDates.sort()

                } else {
                    
                    if let indexToDelete = challenge.checkedDates.firstIndex(of: date){
                        challenge.checkedDates.remove(at: indexToDelete)

                    } else {
                        print("Cannot extract index for chosen date - \(date).")
                    }
                }
            
                
                
            })
        } catch {
            print("Error occurs saveing ubdates: \(error)")
        }
    }

    
    func deleteChallenge(){
        
        do {
            try realm.write {
                realm.delete(challenge)
            }
        } catch {
            print("Error occurs deleting Challenge: \(error)")
        }
    }
}


extension Date {

    var onlyDate: Date {

        get {
            let calender = Calendar.current
            var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calender.date(from: dateComponents)!
        }
    
    }

}
