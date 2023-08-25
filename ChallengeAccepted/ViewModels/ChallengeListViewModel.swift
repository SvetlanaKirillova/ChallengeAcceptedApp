//
//  ChallengeListViewModel.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 24.08.2023.
//

import Foundation
import RealmSwift


struct ChallengeListViewModel {
    
    let realm = try! Realm()
    
    var challenges: Results<Challenge>?
    
    init() {
        loadChallenges()
    }
    
    mutating func loadChallenges(){
        
        challenges = realm.objects(Challenge.self)
    }
    
    
    func getChallengeBy(index: Int) -> Challenge? {
        if let challengesCount = challenges?.count {
            if index < challengesCount {
                return challenges?[index]
            } else {
                print("Index \(index) is out of range of challenges count \(challengesCount)")
            }
        }
        
        return nil
    }
}
