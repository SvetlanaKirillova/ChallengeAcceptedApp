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
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var typeDescriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var challengeDurationTF: UITextField!

    
    @IBOutlet weak var counterGoalTF: UITextField!


    @IBOutlet weak var counterPropsView: UIView!
    @IBOutlet weak var goalDirectionButton: UIButton!
    
    
    @IBOutlet weak var durationDDButton: UIButton!
    
    let realm = try! Realm()
   
    
    var durationToSave = 0
    let createViewModel = CreateChallengeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeDescriptionLabel.text = K.streakChallDescription
        challengeDurationTF.isEnabled = false
        challengeDurationTF.isHidden = true

        updateView()
        initiateView()
        
    }
    
    
    func initiateView(){
        
        setupDurationMenus()
        setupCounterGoalSignMenus()

    }
    
    
    func updateView(){
        
        if typeSegmentControl.selectedSegmentIndex == 0 {
            
            typeDescriptionLabel.text = K.streakChallDescription
            counterPropsView.isHidden = true
        } else {
            
            typeDescriptionLabel.text = K.counterChallDescription
            counterPropsView.isHidden = false
        }
        setupDurationMenus()
    }
    
    
    func setupDurationMenus(){
        
        var  menuElements = [UIAction]()
        
        for duration in createViewModel.getDurationTitlesFor(
                            type: typeSegmentControl.selectedSegmentIndex == 0 ? .streak: .counter ) {
            
            menuElements.append(UIAction(title: duration, state: .on, handler: { action in
                    self.challengeDurationTF.isHidden = true
            }))
        }
        
        menuElements.append(UIAction(title: "Own", state: .on, handler: { action in
            self.challengeDurationTF.isEnabled = true
            self.challengeDurationTF.isHidden = false
        }))

        durationDDButton.menu = UIMenu(title: "Challenge duration", children: menuElements)
    }
    

    func setupCounterGoalSignMenus(){

        goalDirectionButton.menu = UIMenu(children: [
            UIAction(title: GoalSign.lessThan.rawValue , state: .on, handler: { action in
            } ),
            UIAction(title: GoalSign.moreThan.rawValue , handler: { action in
            })
        ])
    }
    
    
    // MARK: - Saving New Challenge
    
    @IBAction func saveChallengeButtonPressed(_ sender: UIButton) {
        
        let title = titleTextField.text!
        let type = typeSegmentControl.selectedSegmentIndex == 0 ? ChallengeType.streak: ChallengeType.counter
        
        if durationDDButton.titleLabel?.text == "Own" {

            durationToSave = Int(challengeDurationTF.text ?? "0")!
            
        } else {
            if let durationTitle = durationDDButton.titleLabel?.text {
                durationToSave = createViewModel.getDurationFor(type: type, title: durationTitle)
            } else {
                print("Error: Cannot extract duration title!")
            }
            
        }
        
        let counterChallengeGoal = Int(counterGoalTF.text ?? "0")
        var counterChallengeDirection: GoalSign?
        if type == .counter {
            counterChallengeDirection = (goalDirectionButton.titleLabel?.text == GoalSign.lessThan.rawValue) ? GoalSign.lessThan : GoalSign.moreThan
        }
            
        createViewModel.createNewChallenge(title: title,
                                              type: type,
                                              duration: durationToSave,
                                              goal: counterChallengeGoal,
                                              goalDirection: counterChallengeDirection)
        
        
        self.performSegue(withIdentifier: K.segueUnwindCreateViewController , sender: self)

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
        updateView()

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
