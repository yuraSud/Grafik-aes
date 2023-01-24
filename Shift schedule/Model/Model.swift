//
//  Model.swift
//  Shift schedule
//
//  Created by YURA																			 on 05.01.2023.
//

import Foundation
import UIKit



class CalendarDate {
   
    var aGrafik = [9,9,3,3,3,9,9,2,2,2,9,9,1,1,1]
    var bGrafik = [9,2,2,2,9,9,1,1,1,9,9,3,3,3,9]
    var vGrafik = [1,1,1,9,9,3,3,3,9,9,2,2,2,9,9]
    var gGrafik = [3,3,9,9,2,2,2,9,9,1,1,1,9,9,3]
    var dGrafik = [2,9,9,1,1,1,9,9,3,3,3,9,9,2,2]
    
    let calendar = Calendar.current
    //let month = ["Січ", "Лют","Бер", "Кві", "Тра", "Чер", "Лип", "Сер", "Вер", "Жов", "Лис", "Гру"]
    let dictHoliday = [1:[1,7], 3:[8], 5:[1,9], 6:[28], 7:[28], 8:[24], 10:[14], 12:[25]]
    
    func setGrafikAES(index: Int){
        switch index {
        case 0: aGrafik = [9,9,3,3,3,9,9,2,2,2,9,9,1,1,1]
                bGrafik = [9,2,2,2,9,9,1,1,1,9,9,3,3,3,9]
                vGrafik = [1,1,1,9,9,3,3,3,9,9,2,2,2,9,9]
                gGrafik = [3,3,9,9,2,2,2,9,9,1,1,1,9,9,3]
                dGrafik = [2,9,9,1,1,1,9,9,3,3,3,9,9,2,2]
    
        case 1: aGrafik = [9,0,0,0,9,9,16,16,16,9,9,8,8,8,9]
                bGrafik = [9,9,8,8,8,9,9,0,0,0,9,9,16,16,16]
                vGrafik = [16,16,16,9,9,8,8,8,9,9,0,0,0,9,9]
                gGrafik = [0,9,9,16,16,16,9,9,8,8,8,9,9,0,0]
                dGrafik = [8,8,9,9,0,0,0,9,9,16,16,16,9,9,8]
            
            
        case 2: aGrafik = [9,1,1,1,9,9,3,3,3,9,9,2,2,2,9]
                bGrafik = [3,3,3,9,9,2,2,2,9,9,1,1,1,9,9]
                vGrafik = [2,2,9,9,1,1,1,9,9,3,3,3,9,9,2]
                gGrafik = [1,9,9,3,3,3,9,9,2,2,2,9,9,1,1]
                dGrafik = [9,9,2,2,2,9,9,1,1,1,9,9,3,3,3]
            
        case 3: aGrafik = [1,9,9,3,3,3,9,9,2,2,2,9,9,1,1]
                bGrafik = [2,2,9,9,1,1,1,9,9,3,3,3,9,9,2]
                vGrafik = [9,1,1,1,9,9,3,3,3,9,9,2,2,2,9]
                gGrafik = [3,3,3,9,9,2,2,2,9,9,1,1,1,9,9]
                dGrafik = [9,9,2,2,2,9,9,1,1,1,9,9,3,3,3]
        default: break
        }
    }
    var dateToStart: Date = {
        let calendar = Calendar.current
        var dateComp = DateComponents()
        dateComp.year = 2008
        dateComp.month = 7
        dateComp.day = 1
        let dateToStart = calendar.date(from: dateComp)!
        return dateToStart
    }()
    
    func nextMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    func previousMonth(date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "UK")//.current
        dateFormatter.dateFormat = "MMM yyyy"
        let monthFormat = dateFormatter.string(from: date)
        return monthFormat.uppercased()
    }
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    func dayInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    func firstDayOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday!
    }
    func month(date: Date) -> Int {
        let components = calendar.dateComponents([.month], from: date)
        return components.month!
    }
    
    func weekendsArray(date: Date) -> [Int] {
        var dayweekends = [Int]()
        let daysInMounth = dayInMonth(date: date)
        let components = calendar.dateComponents([.month, .year], from: date)
        let monthYear = [components.month!, components.year!]
        let indexWeekend = [1,7]
        
        for day in 1...daysInMounth {
            var dateComp = DateComponents()
            dateComp.year = monthYear[1]
            dateComp.month = monthYear[0]
            dateComp.day = day
            guard let dateChange = calendar.date(from: dateComp) else {break}
            if indexWeekend.contains(weekDay(date: dateChange)) {
                dayweekends.append(day)
            }
        }
        return dayweekends
    }
    
    func holidayMonthDay(date: Date) -> [Int]? {
        let components = calendar.dateComponents([.month], from: date)
        let month = components.month!
        return dictHoliday[month]
    }
    
    func dateIsEqual(currentDate: Date, selectedDate: Date) -> Bool {
        let compon1 = calendar.dateComponents([.day ,.month, .year], from: currentDate)
        let compon2 = calendar.dateComponents([.day ,.month, .year], from: selectedDate)
        return compon1 == compon2 ? true : false
       }
    func timeDayInterval(currentDate: Date) -> Int {
        let currentStartDayMonth = firstDayOfMonth(date: currentDate)
        let timeInterval = currentStartDayMonth.timeIntervalSince(dateToStart)/60/60/24
        return Int(timeInterval) % 15
    }
    func configureGraf(modelArray:[Int], dayIndex: Int, allDayinMonth: Int) -> [Int] {
        var finalArr = [Int]()
        var dayOfIndex = dayIndex
        while finalArr.count <= allDayinMonth{
            if dayOfIndex < modelArray.count {
                finalArr.append(modelArray[dayOfIndex])
                dayOfIndex += 1
            } else {
                dayOfIndex = 0
                finalArr.append(modelArray[dayOfIndex])
                dayOfIndex += 1
            }
        }
        return finalArr
    }
    
}
