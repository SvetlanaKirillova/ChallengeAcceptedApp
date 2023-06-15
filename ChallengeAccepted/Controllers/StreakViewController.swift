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

    

    @IBOutlet weak var anim: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nDays: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progresDescription: UILabel!
    @IBOutlet weak var progressView: UIView!
    
    
    let realm = try! Realm()
    var theChallenge: Challenge?
    var calendarVC: CalendarViewController?
    var markRecognizer: MarkGestureRecognizer!
    var markView: UIView!
    
    private var comletionAnimationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        anim.isHidden = true
        
        guard let theChallenge = theChallenge else {
            fatalError("Navigation Controller does not exist.")
        }
        
        calendarVC = self.children.first as? CalendarViewController
        
        title = theChallenge.title
        
        questionLabel.text = "Double tap to mark today"
        progressView.layer.cornerRadius = 10
        
        updateView()
        
    }
    
    func updateView(){
        
        updateCalendarView()
        nDays.text = String(theChallenge!.streak)
        
        
        progressBar.progress = theChallenge?.progress ?? 0
        
        progresDescription.text = "To achieve your goal, you need \(Int(theChallenge!.goal - theChallenge!.streak )) more days"
        if theChallenge?.progress == 1 {
            runComletionGoalAnimation()
        }
    }
    
    func updateCalendarView(){
        
        if let theChallenge = theChallenge {
            
            calendarVC?.reloadSelectedDates(with: Array(theChallenge.checkedDates))
        }
    }
    
    
    func saveTodayCheck(isDone: Bool){
        do {
            try realm.write({
                
                if let theChallenge = theChallenge {
                    theChallenge.todayCheck = isDone
                   
                    if isDone {
                        theChallenge.count += 1
                        theChallenge.checkedDates.append(Date())

                    } else {
                        theChallenge.count -= 1
                        theChallenge.checkedDates.removeLast()
                    }

                    updateView()
                    
                }
                
                
            })
        } catch {
            print("Error occurs updating object: \(error)")
        }
    }
    
    // MARK: - Animation Methods
    
    func runDoneAnimation(){
        
        anim.isHidden = false
        
        // 1. Set animation content mode
          
          anim.contentMode = .scaleAspectFit
          
          // 2. Set animation loop mode
          
        anim.loopMode = .playOnce
          
          // 3. Adjust animation speed
          
        anim.animationSpeed = 0.9
          
          // 4. Play animation
        anim.play { ifDone in
            self.anim.isHidden = true
        }
        
    }
    
    func runComletionGoalAnimation(){
        
        comletionAnimationView = .init(name: "final")
          
        comletionAnimationView!.frame = view.bounds
          
        // 3. Set animation content mode
          
        comletionAnimationView!.contentMode = .scaleAspectFit
          
          // 4. Set animation loop mode
          
        comletionAnimationView!.loopMode = .playOnce
          
          // 5. Adjust animation speed
          
        comletionAnimationView!.animationSpeed = 0.5
          
        view.addSubview(comletionAnimationView!)
          
          // 6. Play animation
          
        comletionAnimationView!.play { whenDone in
            self.comletionAnimationView?.isHidden = true
        }
        
//        comletionAnimationView?.isHidden = true
          
    }
    
    // MARK: - Mark Recognizer Methods
    
    func addMarkRecognizer(){
        
        markRecognizer = MarkGestureRecognizer(target: self, action: #selector(marked))
        markView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        markView.backgroundColor = .white
        view.addSubview(markView)
//        markView.isHidden = true
        markView.addGestureRecognizer(markRecognizer)
    }
    
    @objc func marked( touch: MarkGestureRecognizer) {
      if touch.state == .ended {
          let center = touch.location(in: markView)
//        findCircledView(center)
//          markView
//          markView.updatePath(touch.path)
          print("Tapped center \(center)")
          
          
      }
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
