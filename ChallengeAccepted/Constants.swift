//
//  Constants.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 07.04.2023.
//

import Foundation

struct K {
    
    static let calendarCellIdentifier = "dayCell"
    static let calendarCellNib = "CalendarCell"
    static let monthHeaderId = "MonthHeader"
    
    static let challengeCellId = "challengeCell"
    static let challengeCellNib = "ChallengeCell"
    
    static let ticketCellId = "ticketCell"
    static let ticketCellNib = "TicketCollectionCell"
    
    static let segueToStreakChallenge = "goToStreakChallenge"
    static let segueToCounterChallenge = "goToCounterChallenge"
    static let segueUnwindCreateViewController = "unwindCreateVC"
    
    static let streakChallDescription = "Do the Challenge everyday to save the streak"
    static let counterChallDescription = "The challenge is to aim for an upper or lower limit"
    
    struct colors {
        static let dark = "BrandDark"
        static let green = "BrandGreen"
        static let lightGreen = "BrandLightGreen"
        static let red = "BrandRed"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
        static let lightPurple = "BrandLightPurple"
        static let orange = "BrandOrange"
    }
}
