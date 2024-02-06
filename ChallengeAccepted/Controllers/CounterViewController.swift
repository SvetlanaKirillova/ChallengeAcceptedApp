//
//  CounterViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 16.03.2023.
//

import UIKit
import RealmSwift
import Lottie

class CounterViewController: UIViewController {

    
    @IBOutlet weak var goalUntilDescription: UILabel!

    @IBOutlet weak var ticketsCollectionView: UICollectionView!
    
    @IBOutlet weak var plusImageView: UIImageView!
    
    private var comletionAnimationView: LottieAnimationView?
    
    let realm = try! Realm()

    var challengeViewModel: ChallengeViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        ticketsCollectionView.dataSource = self
        ticketsCollectionView.delegate = self
        
        
        initiateHeaderView()
    }
    
    
    func initiateHeaderView(){
        
        if let challengeViewModel = challengeViewModel {
            
            title = challengeViewModel.title
            
            if challengeViewModel.counterChallengeDirection == .lessThan {
                plusImageView.isHidden = true
            }
            
            let untilDate = challengeViewModel.challengeEndDate
            
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
            
            if challengeViewModel.counterStatus == .inProgress {
                
                switch challengeViewModel.counterChallengeDirection {
                    
                case .lessThan:
                    goalUntilDescription.text = "Use maximum \(challengeViewModel.counterGoal) tickets until \(formatter.string(from: untilDate) )"
                default:
                    goalUntilDescription.text = "Create munimum \(challengeViewModel.counterGoal) tickets until \(formatter.string(from: untilDate))"
                }
            } else {
                showStatusChallengeMessage()
            }
        }
        
    }
    
    
    func showStatusChallengeMessage(){
        
        switch challengeViewModel?.counterStatus {
        case .completed:
            goalUntilDescription.text = "Awesome! Challenge completed!"
        case .failed:
            goalUntilDescription.text = "Challenge was not completed..."
        default: break
            
        }
            
    }
    
    
    @IBAction func plusCounterTapped(_ sender: UITapGestureRecognizer) {
        saveTicketUsageToRealm()
    }
    
    
    func saveTicketUsageToRealm(){
        
        if let challengeViewModel = challengeViewModel {
            challengeViewModel.updateCheckedDate(date: Date(), isDone: true)
            
            if challengeViewModel.counterStatus == .completed {
                
            }
            ticketsCollectionView.reloadData()
            
            if challengeViewModel.counterStatus == .completed {
                runComletionGoalAnimation()
            }
            
        }

    }
    
    


    // MARK: - Realm Challenge
    @IBAction func deleteItemPressed(_ sender: UIBarButtonItem) {
        
        if let challengeViewModel = challengeViewModel {
            let alert = UIAlertController(title: "Delete \(challengeViewModel.title ) Challenge", message: "Are you sure you want to delete this challenge?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
              
                challengeViewModel.deleteChallenge()

                self.navigationController?.popViewController(animated: true)
            
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
        
    }
    
    
    func runComletionGoalAnimation(){
        
        comletionAnimationView = .init(name: "final")
          
        comletionAnimationView?.frame = view.bounds
          
        comletionAnimationView?.contentMode = .scaleAspectFit
          
        comletionAnimationView!.loopMode = .playOnce
          
        comletionAnimationView!.animationSpeed = 0.3
          
        view.addSubview(comletionAnimationView!)
          
        comletionAnimationView!.play { whenDone in
            self.comletionAnimationView?.isHidden = true
        }
          
    }
}


// MARK: - Collection View DataSource and Delegate Methods

extension CounterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let challengeViewModel = challengeViewModel {
            return challengeViewModel.ticketsCount
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.ticketCellId, for: indexPath) as? TicketCollectionCell else {
            fatalError()
        }
        
        if challengeViewModel?.counterChallengeDirection == .lessThan {
            let tgr = UITapGestureRecognizer(target: self, action: #selector(ticketCellTapped))
            tgr.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tgr)
        }
        
 
        return cell
    }
    
    
    @objc func ticketCellTapped(_ recognizer: UITapGestureRecognizer) {

        if let ownerView = recognizer.view as? TicketCollectionCell {
            ownerView.playRipTicketAnimation(finished: {
                self.saveTicketUsageToRealm()
            })
            
        } else {
            print("ERROR: Cannot downcast Recognizer view of Tap Gesture Recignizer!")
        }
        
    }
    
}
