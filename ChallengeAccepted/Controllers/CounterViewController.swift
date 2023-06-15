//
//  CounterViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 16.03.2023.
//

import UIKit
import RealmSwift

class CounterViewController: UIViewController {

    
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    let realm = try! Realm()
    var theChallenge: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateView()
    }
    
    func updateView(){
        
        challengeNameLabel.text = theChallenge?.title
    }

    @IBAction func stepperTapped(_ sender: UIStepper) {
    }
    
}
