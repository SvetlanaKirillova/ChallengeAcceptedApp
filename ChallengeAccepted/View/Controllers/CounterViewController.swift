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

    
    @IBOutlet weak var challengeNameLabel: UILabel!
    
    @IBOutlet weak var goalUntilDescription: UILabel!

    @IBOutlet weak var ticketsCollectionView: UICollectionView!
    
  
    let realm = try! Realm()

    var challengeViewModel: ChallengeViewModel?
    
    var ticketsArray = [String]()
    
    var leftTicketsCount: Int {
        if let challengeViewModel = challengeViewModel {
            if challengeViewModel.counterGoal - challengeViewModel.checkedDates.count > 0 {
                return challengeViewModel.counterGoal - challengeViewModel.checkedDates.count
            }
        }
        
        print(" There are tickets count is out of goal...")
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        ticketsCollectionView.dataSource = self
        ticketsCollectionView.delegate = self
        
        initiateHeaderView()
    }
    
    
    func initiateHeaderView(){
        
        if let challengeViewModel = challengeViewModel {
            challengeNameLabel.text = challengeViewModel.title
            
            let untilDate = Calendar.current.date(byAdding: .day,
                                                  value: challengeViewModel.duration,
                                                  to: challengeViewModel.startDate)!
            
            let formatter = DateFormatter()
            
            formatter.setLocalizedDateFormatFromTemplate("dd.MM.YYYY")
            
            switch challengeViewModel.counterChallengeDirection {
                
            case .lessThan:
                goalUntilDescription.text = " use maximum \(challengeViewModel.counterGoal) tickets until \(formatter.string(from: untilDate) )"
            default:
                goalUntilDescription.text = " use munimum \(challengeViewModel.counterGoal) tickets until \(formatter.string(from: untilDate))"
                
            }
        }
        
    }
    
    
    func saveTicketUsageToRealm(){
        
        if let challengeViewModel = challengeViewModel {
            challengeViewModel.updateCheckedDate(date: Date(), isDone: true)
            ticketsCollectionView.reloadData()
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
    
    
}


// MARK: - Collection View DataSource and Delegate Methods

extension CounterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return leftTicketsCount

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.ticketCellId, for: indexPath) as? TicketCollectionCell else {
            fatalError()
        }
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(ticketCellTapped))
        tgr.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tgr)
 
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
