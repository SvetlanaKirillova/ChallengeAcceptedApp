//
//  StreakViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 16.03.2023.
//

import UIKit
import RealmSwift
import SnapKit
import TTCalendarPicker
import Lottie

class StreakViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nDays: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progresDescription: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var dateToCheckLabel: UILabel!
//    @IBOutlet weak var selectedDateButton: UIButton!
    @IBOutlet weak var dateToCheckView: UIView!
    
    
    
    let realm = try! Realm()
    var challengeViewModel: ChallengeViewModel?
//    var theChallenge: Challenge?
    var calendarVC: CalendarViewController?
    var markRecognizer: MarkGestureRecognizer!
    var markView: UIView!
    
    private var comletionAnimationView: LottieAnimationView?
    private var todayDoneAnimationView: LottieAnimationView?
    
    var selectedDateToCheck = Date().onlyDate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let theChallengeViewModel = challengeViewModel else {
            fatalError("Challenge View Model does not exist.")
        }
        
        calendarVC = self.children.first as? CalendarViewController
        
        title = theChallengeViewModel.title
        
//        questionLabel.text = "Double tap to check date"
        progressView.layer.cornerRadius = 10
        dateToCheckView.layer.cornerRadius = 30
        
        updateViews()
        
    }
    
    
    func updateViews(){
        
        updateCalendarView()

        nDays.text = String(challengeViewModel!.streakValue)
        updateCheckDateView()
        updateProgressView()
    }
    
    
    func updateCalendarView(){
        
        
        if let  challengeViewModel = challengeViewModel {
            
            calendarVC?.reloadSelectedDates(with: challengeViewModel.checkedDates)

        }
    }
    
    
    func updateProgressView(){
        
        if let challengeViewModel = challengeViewModel {
            let progress = challengeViewModel.progress
            progressBar.progress = progress
                
            progresDescription.text = challengeViewModel.progressDescription
            
            if progress == 1 {
                runComletionGoalAnimation()
            }
        
        } else {
            print("ERROR: Controller doesn't have challenge view model object!")
        }
        
    }
    
    
    // MARK: - Mark Selected Date Methods
    
    func updateCheckDateView(withDate date:Date){
        
        let dateFormat = DateFormatter()
        dateFormat.setLocalizedDateFormatFromTemplate("dd MMMM")
        dateToCheckLabel.text = dateFormat.string(from: date)

        print("Date wad picked: \(date)")
        selectedDateToCheck = date
        dateToCheckView.isUserInteractionEnabled = true
    }
    
    
    func updateCheckDateView(){
        
        dateToCheckLabel.text = "Select a date from a calendar"
        dateToCheckView.isUserInteractionEnabled = false
        
    }
    
    
    @IBAction func selectedDateTapHandler(_ sender: UITapGestureRecognizer) {
        if let challengeViewModel = challengeViewModel {
            
            if !challengeViewModel.checkedDates.contains(selectedDateToCheck){
                saveCheck(forDate: selectedDateToCheck, isDone: true)
                runTodayDoneAnimation()
            }
        }

    }
    
    
    func saveCheck(forDate theDate: Date, isDone: Bool){
        challengeViewModel?.updateCheckedDate(date: theDate, isDone: isDone)
        updateViews()

    }
    
    
    // MARK: - Animation Methods
    
    func runTodayDoneAnimation(){
        
        todayDoneAnimationView = .init(name: "done")

        todayDoneAnimationView?.frame = view.bounds
        
        todayDoneAnimationView?.contentMode = .scaleAspectFit

        todayDoneAnimationView?.loopMode = .playOnce
          
 
        todayDoneAnimationView?.animationSpeed = 0.9
          
        view.addSubview(todayDoneAnimationView!)
        
        todayDoneAnimationView?.play { ifDone in
            self.todayDoneAnimationView?.isHidden = true
            self.updateViews()
        }
        
    }
    
    
    func runComletionGoalAnimation(){
        
        comletionAnimationView = .init(name: "final")
          
        comletionAnimationView?.frame = view.bounds
          
        comletionAnimationView?.contentMode = .scaleAspectFit
          
        comletionAnimationView!.loopMode = .playOnce
          
        comletionAnimationView!.animationSpeed = 0.5
          
        view.addSubview(comletionAnimationView!)
          
        comletionAnimationView!.play { whenDone in
            self.comletionAnimationView?.isHidden = true
        }
          
    }
    
    
    // MARK: - Mark Recognizer Methods
    
    func addMarkRecognizer(){
        
        markRecognizer = MarkGestureRecognizer(target: self, action: #selector(marked))
        markView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        markView.backgroundColor = .white
        view.addSubview(markView)

        markView.addGestureRecognizer(markRecognizer)
    }
    
    
    @objc func marked( touch: MarkGestureRecognizer) {
      if touch.state == .ended {
          let center = touch.location(in: markView)

          print("Tapped center \(center)")
          
          
      }
    }

    
    // MARK: - Delete Challenge
    
    @IBAction func deleteItemPressed(_ sender: UIBarButtonItem) {
        
        if let challengeViewModel = challengeViewModel{
            let alert = UIAlertController(title: "Delete \(challengeViewModel.title ) Challenge",
                                          message: "Are you sure you want to delete this challenge?",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            
//                self.deleteChallenge(challenge: self.theChallenge)
                challengeViewModel.deleteChallenge()
                self.performSegue(withIdentifier: "afterDelete", sender: self) // todo: is it necessary to use unwind seque?
            
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
        
    }
    
    

}
