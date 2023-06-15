//
//  SelectedChallengeViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 03.03.2023.
//

import UIKit
import RealmSwift

class SelectedChallengeViewController: UIViewController {
    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var todayDate: UILabel!
//    @IBOutlet weak var todayCheck: UISwitch!
//    @IBOutlet weak var nDays: UILabel!
//    @IBOutlet weak var questionLabel: UILabel!
//    @IBOutlet weak var stepper: UIStepper!
    
    
    let realm = try! Realm()
    var theChallenge: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let theChallenge = theChallenge else {
//            fatalError("Navigation Controller does not exist.")
//        }
//        
//        todayDate.text = Date().formatted(date: .abbreviated, time: .omitted)
//        titleLabel.text = theChallenge.title
//        nDays.text = String(theChallenge.count)
//        todayCheck.isOn = theChallenge.todayCheck
//        
    }
    
    
    
    

    
    // MARK: - Delete Challenge
    @IBAction func deleteItemPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Delete \(theChallenge!.title ) Challenge", message: "Are you sure you want to delete this challenge?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        
            print("Ok button tapped")
            self.deleteChallenge(challenge: self.theChallenge)
            self.performSegue(withIdentifier: "afterDelete", sender: self)
        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func deleteChallenge(challenge: Challenge?){
        
        if let challengeToDelete = challenge{
            do {
                try realm.write {
                    realm.delete(challengeToDelete)
                }
            } catch {
                print("Error occurs deleting Challenge: \(error)")
            }
        }
        
        
    }
}

