//
//  ChallengeCell.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 09.06.2023.
//

import UIKit

class ChallengeCell: UITableViewCell {

    @IBOutlet weak var challengeName: UILabel!
    
    @IBOutlet weak var progress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
