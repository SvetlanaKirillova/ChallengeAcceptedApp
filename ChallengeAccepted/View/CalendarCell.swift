//
//  CollectionViewCell.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 30.03.2023.
//

import UIKit
import Lottie

class CalendarCell: UICollectionViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    
//    @IBOutlet weak var checkmarkImage: UIImageView!
    
    @IBOutlet weak var view: UIView!
//    @IBOutlet weak var checkAnimationView: LottieAnimationView!
    
    private var checkAnimationView: LottieAnimationView?
    
    
    var isInVisibleMonth: Bool = true {
        didSet {
            updateLabelColor()
            updateCheckMarkVisible()
        }
    }
    
    var isTodayCell = false
    
    override var isSelected: Bool {
        didSet {
            updateCheckMarkVisible()

        }
    }
    
    var tgr: UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        checkmarkImage.isHidden = true
//        checkAnimationView.isHidden = true

        
        tgr = UITapGestureRecognizer(target: self, action: #selector(dayTapped))
        tgr?.numberOfTapsRequired = 2

//        self.addGestureRecognizer(tgr)
        
        checkAnimationView = .init(name: "checkmark")
        checkAnimationView!.frame = view.bounds
          
        checkAnimationView!.contentMode = .scaleAspectFill

        checkAnimationView!.loopMode = .playOnce
        checkAnimationView!.animationSpeed = 2.9
        
    
        checkAnimationView?.play()
        view.addSubview(checkAnimationView!)
//        checkAnimationView?.pause()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    private func updateLabelColor() {
        if isSelected {
            dateLabel.textColor = .white
        } else if isInVisibleMonth {
            dateLabel.textColor = .white
        } else {
            dateLabel.textColor = UIColor(white: 0.5, alpha: 1)
            
        }
    }


    private func updateCheckMarkVisible(){
        if isSelected {
//            checkmarkImage.isHidden = false
            checkAnimationView?.isHidden = false
            
        } else {
//            checkmarkImage.isHidden = true
            checkAnimationView?.isHidden = true
        }
    }
    
    func makeClickable(yesOrNo: Bool){
        
        self.isUserInteractionEnabled = yesOrNo
//        checkmarkImage.isUserInteractionEnabled = yesOrNo
//        checkmarkImage.isMultipleTouchEnabled = yesOrNo

        
    }
    
    
    func isItTodayCell(isToday: Bool) {
        
        if isToday && isInVisibleMonth {
            view.backgroundColor = UIColor(named: K.colors.orange )
//            dateLabel.textColor = .white
            makeClickable(yesOrNo: true)
            isTodayCell = true
            
            
            if let tapGestureRecognizer = tgr {
                self.addGestureRecognizer(tapGestureRecognizer)
//                self.addGestureRecognizer(tapGestureRecognizer)
            }
            
            
        } else {
            view.backgroundColor = UIColor(named: K.colors.lightBlue)
            makeClickable(yesOrNo: false)
            if let tapGestureRecognizer = tgr {
//                self.removeGestureRecognizer(tapGestureRecognizer)
            }
//
            
        }
    }
    
    @objc private func dayTapped(_ recognizer: UITapGestureRecognizer) {
        
        print("We have double tap!\(recognizer.location(ofTouch: 0, in: self.view))")
        let parent = self.parentContainerViewController() as? StreakViewController
        
        if isSelected == true {
            isSelected = false
            parent?.saveTodayCheck(isDone: isSelected)
        } else {


            checkAnimationView?.isHidden = false
            checkAnimationView?.animationSpeed = 0.9
//            view.addSubview(checkAnimationView!)
            checkAnimationView?.play(completion: { ifDone in
                self.isSelected = true
                self.saveTodayCheck(fromParent: parent!, isDone: true)

            })
          
        }
        
    }
    
    func saveTodayCheck(fromParent parent: StreakViewController, isDone: Bool){
        parent.saveTodayCheck(isDone: isDone)
    }
    
//    func runCheckAnimation(onView: UIView, finished:  @escaping () -> Void){
//        print(onView)
//
//        checkAnimationView = .init(name: "checkmark")
//
//        checkAnimationView!.frame = onView.bounds
//
//        checkAnimationView!.contentMode = .scaleAspectFill
//
//        checkAnimationView!.loopMode = .playOnce
//
//
//        checkAnimationView!.animationSpeed = 0.9
//        onView.addSubview(checkAnimationView!)
//
//          // 4. Play animation
//        checkAnimationView!.play { whenDone in
//            self.checkAnimationView?.isHidden = true
////            self.isSelected = true
////            finished()
//        }
//
//
//    }
//

}
