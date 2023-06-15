//
//  CreateChallengeViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 27.02.2023.
//

import UIKit
import RealmSwift

class CreateChallengeViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var typeDescriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var streakGoalCount: UITextField!
    @IBOutlet weak var streakGoalCountStepper: UIStepper!
    
    @IBOutlet weak var counterGoalCount: UITextField!
    //    @IBOutlet weak var goalSignPicker: UIPickerView!

    @IBOutlet weak var counterPropsView: UIView!
    @IBOutlet weak var goalDirectionButton: UIButton!
    
    let realm = try! Realm()
    
    let streakChallDescription = "It is necessary to fulfill the conditions of the challenge a certain number of days in a row"
    let counterChallDescription = "Counter type Challenge"
    
    var counterGoalDirection: GoalSign?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up pull down menu button
        let menuClosure = {(action: UIAction) in
            self.saveCounterGoalSign(sign: action.title)
        }
        goalDirectionButton.menu = UIMenu(children: [
            UIAction(title: GoalSign.lessThan.rawValue , state: .on, handler:
                                        menuClosure),
            UIAction(title: GoalSign.moreThan.rawValue , handler: menuClosure),
                ])
        
        typeDescriptionLabel.text = streakChallDescription
        streakGoalCount.text = String(Int(streakGoalCountStepper.value))
        
        updateView()
    }
    
    func saveCounterGoalSign(sign: String) {
        if sign == GoalSign.lessThan.rawValue {
            print("option 1 selected")
            counterGoalDirection = GoalSign.lessThan
        } else if sign == GoalSign.moreThan.rawValue {
            counterGoalDirection = GoalSign.moreThan
        }
       
    }
    
    // MARK: - Saving New Challenge
    
    @IBAction func saveChallenge(_ sender: UIButton) {
        
        let title = titleTextField.text!
        
        let newChallenge = Challenge()
        newChallenge.title = title
        
        if type.selectedSegmentIndex == 0 {
            newChallenge.type = ChallengeType.streak
            newChallenge.goal = Int(streakGoalCountStepper.value)
            
        } else {
            newChallenge.type = ChallengeType.counter
            if !counterGoalCount.text!.isEmpty {
                
                newChallenge.goal = Int(counterGoalCount.text!)!
            } else {
//                counterGoalCount.
                return
            }
            
//            newChallenge.counterGoalDirection = counterGoalDirection!
        }
        
        
        
        do {
            try realm.write{
                realm.add(newChallenge)
            }
        
//            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "unwindCreateVC", sender: self)
            
        } catch {
            print("Error creating Challenge: \(error)")
        }
        
    }
    
    
    // MARK: - Cancel Creating New Challenge
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Configuring New Challenge Parameters
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }

    
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        
//        type.selectedSegmentIndex = sender.selectedSegmentIndex
        updateView()
//        if sender.selectedSegmentIndex == 0 {
//            typeDescriptionLabel.text = streakChallDescription
//            counterPropsView.isHidden = true
//
//        } else if sender.selectedSegmentIndex == 1 {
//            typeDescriptionLabel.text = counterChallDescription
//            counterPropsView.isHidden = false
//        }
    }
    
    
    @IBAction func goalStepperTapped(_ sender: UIStepper) {
        streakGoalCount.text = String(Int(streakGoalCountStepper.value))
    }
    
    
    @IBAction func goalNumberEditing(_ sender: UITextField) {
        
        if let number = sender.text {
            
            if number.isEmpty {
                streakGoalCountStepper.value = 0
            } else {
                streakGoalCountStepper.value = Double(number) ?? 1
            }
        }
        
        
    }
    
    
    func updateView(){
        if type.selectedSegmentIndex == 0 {
            
            typeDescriptionLabel.text = streakChallDescription
            counterPropsView.isHidden = true
        } else {
            
            typeDescriptionLabel.text = counterChallDescription
            counterPropsView.isHidden = false
        }
    }
    
    

    @IBAction func counterGoalNumChanging(_ sender: UITextField) {
        
    }
    
//    // MARK: - to dissmiss keyboard
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.titleTextField.endEditing(true)
//        self.streakGoalCount.endEditing(true)
//    }
}


// MARK: - UIPickerView Methods
//
//extension CreateChallengeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return GoalSign.allCases.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        return GoalSign.allCases[row].rawValue
//    }
//}
//extension CreateChallengeViewController: UITextFieldDelegate{
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("text field begin edidting")
//    }
//}
