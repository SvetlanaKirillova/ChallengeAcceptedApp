//
//  MonthHeaderView.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 27.03.2023.
//

import UIKit

class MonthHeaderView: UICollectionReusableView {
    
    let monthLabel: UILabel
    let stackView: UIStackView

    
    var dayOfWeekHeaders: [String] = [] {
        didSet {
            stackView.subviews.forEach({
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            })

            dayOfWeekHeaders.forEach({
                let label = UILabel()
                label.font = UIFont.boldSystemFont(ofSize: 10)
                label.text = $0
                label.textAlignment = .center
                label.textColor = .white
                stackView.addArrangedSubview(label)
            })
        }
    }

    
    override init(frame: CGRect) {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually

        monthLabel = UILabel()
        monthLabel.font = UIFont.systemFont(ofSize: 18)
        monthLabel.textAlignment = .center
        monthLabel.textColor = .white
        
        super.init(frame: frame)

        addSubview(stackView)
        addSubview(monthLabel)

        monthLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
//            print("Superview = \( )")
        }

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
//            make.top.
            make.top.equalTo(monthLabel.snp.bottom).offset(7)
            make.bottom.equalToSuperview().inset(4)
        }
        
        
//        stackView.backgroundColor = UIColor(named: K.colors.lightGreen)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
