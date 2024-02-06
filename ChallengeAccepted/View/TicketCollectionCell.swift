//
//  TicketCollectionCell.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 20.06.2023.
//

import UIKit
import Lottie

class TicketCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    private var ticketAnimation: LottieAnimationView?
    
    enum ticketAnimationKeyFrames: CGFloat {
      
      case start = 0
      case rollTicket = 85
      case startRip = 90
      case endAnim = 160
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        layer.borderWidth = 0.2
//        layer.borderColor = UIColor(named: K.colors.blue )?.cgColor
        
        ticketAnimation = .init(name: "ticket")
        
        ticketAnimation!.frame = baseView.bounds
        ticketAnimation!.contentMode = .scaleAspectFill
        
        baseView.addSubview(ticketAnimation!)
        
        firstShowTicketsAnimation()
                
    }
    
    
    override func prepareForReuse() {
        refreshTicketsAnimation()
    }
    
    
    // MARK: - Animation Methods
//
    func firstShowTicketsAnimation(){
        ticketAnimation?.play(fromFrame: ticketAnimationKeyFrames.start.rawValue, toFrame:  ticketAnimationKeyFrames.rollTicket.rawValue, loopMode: .playOnce )
    }
    
    
    func refreshTicketsAnimation(){
        ticketAnimation?.play(fromFrame: ticketAnimationKeyFrames.rollTicket.rawValue, toFrame:  ticketAnimationKeyFrames.startRip.rawValue, loopMode: .playOnce )
    }

    
    func playRipTicketAnimation(finished: (() -> Void )?){

        self.ticketAnimation?.play(fromFrame: ticketAnimationKeyFrames.startRip.rawValue , toFrame: ticketAnimationKeyFrames.endAnim.rawValue, loopMode: .none, completion: { whenDone in
                finished?()
        })
    }
    

}
