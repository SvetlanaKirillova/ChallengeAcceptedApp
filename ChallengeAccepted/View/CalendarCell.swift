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

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    private var checkAnimationView: LottieAnimationView?
    
    var isInVisibleMonth: Bool = true {
        didSet {
            updateLabelColor()

        }
    }
    
    var isTodayCell = false
    
    override var isSelected: Bool {
        didSet {
            updateCheckMarkVisible()
            updateLabelColor()
            updateBackgroundColor()
        }
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }


    private func updateLabelColor() {
        
        if isInVisibleMonth {
            
            dateLabel.textColor = .white
            
        } else {
            
            dateLabel.textColor = UIColor(white: 0.5, alpha: 1)
            
        }

    }
    
    
    private func updateBackgroundColor() {
        if isTodayCell {
            
            baseView.backgroundColor = UIColor(named: K.colors.blue)
        } else {
            baseView.backgroundColor = UIColor(named: K.colors.lightBlue)
        }
    }


    private func updateCheckMarkVisible(){

        if isSelected {

            checkmarkImage.isHidden = false

        } else {

            checkmarkImage.isHidden = true
        }

    }
    
    
    func isItTodayCell(isToday: Bool) {

        if isToday {
            isTodayCell = true
        } else {
            isTodayCell = false
        }
        
        updateBackgroundColor()
        updateCheckMarkVisible()

    }

}
