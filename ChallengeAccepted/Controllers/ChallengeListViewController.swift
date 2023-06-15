//
//  ViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 19.02.2023.
//

import UIKit
import RealmSwift



class ChallengeListViewController: UITableViewController {

    let realm = try! Realm()
    
    var challenges: Results<Challenge>?
//    let chl = Challenge()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController!.navigationBar.barStyle = .black
        
        tableView.register(UINib(nibName: K.challengeCellNib, bundle: nil), forCellReuseIdentifier: K.challengeCellId)

        loadChallenges()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.") }
        navBar.barStyle = .black
//        navBar.standardAppearance.backgroundColor = UIColor(named: K.colors.red)!
//        navBar.scrollEdgeAppearance?.backgroundColor = GradientColor( .diagonal, frame:  CGRect(x: 0, y: 0, width: 500, height: 200), colors: [ransomColor, .white])
        tableView.reloadData()
    }
    
    @IBAction func unwindToChallengeVC(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

// MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return challenges?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.challengeCellId, for: indexPath) as! ChallengeCell
    
        if let challenge = challenges?[indexPath.row]{
            cell.challengeName.text = challenge.title
            cell.progress.progress = challenge.progress
        }

        
        return cell
    }
    
// MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            if challenges?[selectedRow.row].type == ChallengeType.streak {
                self.performSegue(withIdentifier: "goToStreakChallenge", sender: self)
            } else {
                self.performSegue(withIdentifier: "goToCounterChallenge", sender: self)
            }
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToStreakChallenge" {
            let destinationVC = segue.destination as! StreakViewController
            
            if let selectedRow = tableView.indexPathForSelectedRow {
                destinationVC.theChallenge = challenges?[selectedRow.row]
            }
        }
        else if segue.identifier == "goToCounterChallenge" {
            let destinationVC = segue.destination as! CounterViewController
            
            if let selectedRow = tableView.indexPathForSelectedRow {
                destinationVC.theChallenge = challenges?[selectedRow.row]
            }
        }
    }
    
// MARK: - Data Manipulation Methods
    
    func loadChallenges(){
        
        challenges = realm.objects(Challenge.self)
        updateTodayCheck()
        tableView.reloadData()
    }
    
    func updateTodayCheck(){
        if let challenges = challenges{
            do {
                try realm.write({
                    
                    for challenge in challenges.filter("type == %@", ChallengeType.streak) {
                        
                        challenge.todayCheck = false
                        for day in challenge.checkedDates  {
                            if day.formatted(date: .numeric, time: .omitted) == Date().formatted(date: .numeric, time: .omitted){
                                challenge.todayCheck = true
                            }
                        }
                    }
                })
            } catch{
                print(error)
            }
            
            
        }

        
    }
    
    
}

