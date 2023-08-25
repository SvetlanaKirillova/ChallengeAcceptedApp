//
//  CalendarViewController.swift
//  ChallengeAccepted
//
//  Created by Svetlana Kirillova on 27.03.2023.
//

import UIKit
import SnapKit
import TTCalendarPicker
import Lottie


class CalendarViewController: UIViewController {
    
    var theChallenge: Challenge?
    private var checkAnimationView: LottieAnimationView?
    
    lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.setLocalizedDateFormatFromTemplate("MMMM, YYYY")
        
        return formatter
    }()

    lazy var dayOfWeekHeaders: [String] = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        
        var weekdaySymbols = dateFormatter.weekdaySymbols!
        
        for _ in 0..<dateFormatter.calendar.firstWeekday-1 {
            weekdaySymbols.append(weekdaySymbols.remove(at: 0))
        }
        return weekdaySymbols.map({ String($0.prefix(2)) })
    }()
    
    var calendar: Calendar {
        
        return calendarPicker.calendar
    }

    var calendarPicker: CalendarPicker
  

    required init?(coder aDecoder: NSCoder) {
 
        
        let date = Date()
        self.calendarPicker = CalendarPicker(date: date)

        super.init(coder: aDecoder)
        
        
        self.calendarPicker.registerDateCell(UINib(nibName: K.calendarCellNib , bundle: nil), withReuseIdentifier: K.calendarCellIdentifier)

        self.calendarPicker.registerMonthHeaderView(MonthHeaderView.self, withReuseIdentifier: "MonthHeader")
        self.calendarPicker.monthHeaderHeight = 45
        self.calendarPicker.calendarHeightMode = .fixed
        self.calendarPicker.dataSource = self
        self.calendarPicker.delegate = self
        self.calendarPicker.cellHeightMode = .aspectRatio(0.9)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarPicker.allowsMultipleSelection = true

        self.calendarPicker.viewBackgrounColor = UIColor(named: K.colors.lightBlue)
//        self.calendarPicker.viewCornerRadius = 10
        self.calendarPicker.gridColor = .white

        initiateView()
    
    }
    
    
    func reloadSelectedDates(with selectedDates: [Date]){

        calendarPicker.selectedDates = selectedDates
        calendarPicker.reloadData()
        
    }
    
    
    func initiateView(){
 
        view.addSubview(calendarPicker)
        
        calendarPicker.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.left.right.equalToSuperview()
        }

    }

}

extension CalendarViewController: CalendarPickerDataSource {
    
    func calendarPicker(_ calendarPicker: CalendarPicker, cellForDay day: Int,
                        month: Int, year: Int, inVisibleMonth: Bool, at indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = calendarPicker.dequeReusableDateCell( withReuseIdentifier: K.calendarCellIdentifier, indexPath: indexPath) as? CalendarCell else {
            fatalError("Cannot deque cell with identifier \(K.calendarCellIdentifier)")
        }
        
        cell.dateLabel.text = String(day)
        cell.isInVisibleMonth = inVisibleMonth
     
        let components = calendarPicker.calendar.dateComponents([.year, .month, .day], from: calendarPicker.today)
        

        if  (components.year == year && components.month == month && components.day == day && inVisibleMonth == true) {
            cell.isItTodayCell(isToday: true)

        } else {
            
            cell.isItTodayCell(isToday: false)
        }
        
        return cell
    }
    
}

extension CalendarViewController: CalendarPickerDelegate {
    
    func calendarPicker(_ calendarPicker: CalendarPicker, headerForMonth month: Int, year: Int, indexPath: IndexPath) -> UICollectionReusableView {

        let header = calendarPicker.dequeMonthHeaderView(withReuseIdentifier: K.monthHeaderId, indexPath: indexPath) as! MonthHeaderView
        let date = DateComponents(calendar: calendarPicker.calendar, year: year, month: month).date!
        header.monthLabel.text = monthFormatter.string(from: date).capitalized
        header.dayOfWeekHeaders = dayOfWeekHeaders

        return header
    }

    func calendarPickerHeightWillChange(_ calendarPicker: CalendarPicker) {
        view.layoutIfNeeded()
    }

    func calendarPickerHeightDidChange(_ calendarPicker: CalendarPicker) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    

    func calendarPicker(_ calendarPicker: CalendarPicker, shouldSelectDate date: Date) -> Bool {

        if let parent = self.parent as? StreakViewController {
            if let challengeVieModel = parent.challengeViewModel {
                if date < challengeVieModel.startDate || date > calendarPicker.today {
                    print("Selected date(\(date) is out of Range")
                    return false
                }
            }
        } else {
            print("ERROR: Cannot downcast parent View Controller!")
        }

        return true
    }
    
    
    func calendarPicker(_ calendarPicker: CalendarPicker, didSelectDate date: Date) {

        print("Selected date \( date.formatted(date: .complete, time: .omitted))")
        if let index = calendarPicker.selectedDates.firstIndex(of: date) {

            calendarPicker.selectedDates.remove(at: index)
        }
        if let parent = self.parent as? StreakViewController {
            parent.updateCheckDateView(withDate: date)
        }
        
    }
    
    
    func calendarPicker(_ calendarPicker: CalendarPicker, didDeselectDate date: Date) {
        if let parent = self.parent as? StreakViewController {
            parent.saveCheck(forDate: date, isDone: false)
        }
    }
    

}





