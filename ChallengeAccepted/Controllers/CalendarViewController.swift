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
        return dateFormatter.weekdaySymbols.map({ String($0.prefix(2)) })
    }()

    var calendar: Calendar {
        
        return calendarPicker.calendar
    }

    var calendarPicker: CalendarPicker
  

    required init?(coder aDecoder: NSCoder) {
        
        var calendarM = Calendar(identifier: .gregorian)
        calendarM.firstWeekday = 2
        
        let date = Date()
        self.calendarPicker = CalendarPicker(date: date, calendar: calendarM)

        super.init(coder: aDecoder)
        
        
        self.calendarPicker.registerDateCell(UINib(nibName: K.calendarCellNib , bundle: nil), withReuseIdentifier: K.calendarCellIdentifier)

        self.calendarPicker.registerMonthHeaderView(MonthHeaderView.self, withReuseIdentifier: "MonthHeader")
        self.calendarPicker.monthHeaderHeight = 45
        self.calendarPicker.calendarHeightMode = .dynamic
        self.calendarPicker.dataSource = self
        self.calendarPicker.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarPicker.allowsMultipleSelection = true
        self.calendarPicker.viewBackgrounColor = UIColor(named: K.colors.lightBlue)
        self.calendarPicker.viewCornerRadius = 10
        

        
        initiateView()
 
        
    }
    
    func reloadSelectedDates(with selectedDates: [Date]){
        //        print("Reloading selected dates in the calendar... \(selectedDates)")
        calendarPicker.selectedDates = selectedDates
        //        print("Calendar picker selected: \(calendarPicker.selectedDates)")
        
        calendarPicker.reloadData()
        
    }
    
    func initiateView(){
 
        view.addSubview(calendarPicker)
        
        calendarPicker.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.left.right.equalToSuperview()
        }

    }

//    func saveSelectedCell(isSelectedCell: Bool){
//        parentVC?.saveTodayCheck(isDone: isSelectedCell)
//    }

}

extension CalendarViewController: CalendarPickerDataSource {
    
    func calendarPicker(_ calendarPicker: CalendarPicker, cellForDay day: Int,
                        month: Int, year: Int, inVisibleMonth: Bool, at indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = calendarPicker.dequeReusableDateCell(
            withReuseIdentifier: K.calendarCellIdentifier,
            indexPath: indexPath)
            as! CalendarCell
        cell.dateLabel.text = String(day)
        cell.isInVisibleMonth = inVisibleMonth
     
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let components = calendarPicker.calendar.dateComponents([.year, .month, .day], from: calendarPicker.today)
        

        if  (components.year == year && components.month == month && components.day == day && inVisibleMonth == true) {
            
//            if !cell.isSelected{
//                runCheckAnimation(onView: cell.view)
//            }
            cell.isItTodayCell(isToday: true)


         
        } else {
            cell.isItTodayCell(isToday: false)
        }
        return cell
    }
    
    func calendarPicker(_ calendarPicker: CalendarPicker, shouldSelectDate date: Date) -> Bool {
        return false
    }
    
    func calendarPicker(_ calendarPicker: CalendarPicker, shouldDeselectDate date: Date) -> Bool {
        return false
    }
    
    func runCheckAnimation(onView: UIView){
        print(onView)

        checkAnimationView = .init(name: "checkmark")
    //        print(view.bounds)
        checkAnimationView!.frame = onView.bounds
        // 1. Set animation content mode
          
        checkAnimationView!.contentMode = .scaleAspectFill
          
          // 2. Set animation loop mode
          
        checkAnimationView!.loopMode = .playOnce
          
          // 3. Adjust animation speed
          
        checkAnimationView!.animationSpeed = 0.9
        onView.addSubview(checkAnimationView!)
          
          // 4. Play animation
        checkAnimationView!.play { whenDone in
            self.checkAnimationView?.isHidden = true
        }
    }
    
    
    
}

extension CalendarViewController: CalendarPickerDelegate {
    
    func calendarPicker(_ calendarPicker: CalendarPicker, headerForMonth month: Int, year: Int, indexPath: IndexPath) -> UICollectionReusableView {

        let header = calendarPicker.dequeMonthHeaderView(withReuseIdentifier: "MonthHeader", indexPath: indexPath) as! MonthHeaderView
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
    
    
}




