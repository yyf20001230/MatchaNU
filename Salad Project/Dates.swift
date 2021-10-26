//
//  Dates.swift
//  Salad Project
//
//  Created by Kevin Su on 26/10/2021.
//

import Foundation

//For testing
func compile() -> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mma"
    
    let testString = "Pick-Staiger Rehearsal Room: Tues, Thurs, 5:00PM - 6:20PM"
    
    let startString = scrapeStartHoursMinutes(rawString: testString)
    let endString =
        scrapeEndHoursMinutes(rawString: testString)
    let classroom = scrapeClassroom(rawString: testString)
    
    
    
    let startTime = newDate(inString: startString)
    let endTime = newDate(inString: endString)
    
    var dateString = ""
    
    let datesList = scrapeDatesOfWeek(rawString: testString)
    
    for item in datesList{
        dateString = dateString + item
    }
    
    return "Times: " + dateFormatter.string(from: startTime) + " to " + dateFormatter.string(from: endTime) + "\n" +  "Classroom: " + classroom + "\n" + "Days of week: " + dateString
}

//    func allTimes(startTime: Date, endTime:Date, classroom: String) -> MeetingTimes{
//        return MeetingTimes{startTime: startTime, endTime: endTime, classroom: classroom}
//
//    }

func newDate(inString: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mma"
    dateFormatter.locale = Locale(identifier: "en_US")
    
    
    guard let new_date = dateFormatter.date(from: inString) else { return (dateFormatter.date(from: "00:00AM")!) }
    
//        guard let new_end_date = dateFormatter.date(from: endString) else { return "failed" }
    
    //dateFormatter.dateFormat = "hh:mm"
    //new_end_date.dateFormat = "HH:mm"
    
    return new_date
}

func getTime(rawString: String) -> String{

    var newString: String
    let lastComma = rawString.lastIndex(of: ",") ?? rawString.startIndex
    newString = String(rawString[rawString.index(after: lastComma)...])
    return newString
}

func scrapeStartHoursMinutes(rawString: String) -> String{
    var newString = getTime(rawString: rawString)
    var firstLetter: Character = "Z"
    for char in newString{
        if char.isLetter{
            firstLetter = char
            break
        }
    }
    let firstLetterIndex = newString.firstIndex(of: firstLetter)
    
    var finalString = String(newString[...newString.index(after: firstLetterIndex!)])
    
    //finalString = finalString +  String(newString[firstLetterIndex!...newString.index(after: firstLetterIndex!)])
    return finalString
}

func scrapeEndHoursMinutes(rawString: String) -> String{
    var newString = getTime(rawString: rawString)
    let hyphenIndex = newString.firstIndex(of: "-")
    newString = String(newString[newString.index(after: hyphenIndex!)...])
    
    
    var finalString = String(newString)
    
    //finalString = finalString + String(newString[firstLetterIndex!...])
    
    return finalString
}

func scrapeDatesOfWeek(rawString: String) -> [String] {
    let startIndex = rawString.index(after: rawString.firstIndex(of: ":")!)
    var newString = String(rawString[startIndex...])
    
    var firstNumber: Character = "Z"
    for char in newString{
        if char.isNumber{
            firstNumber = char
            break
        }
    }
    let endIndex = newString.index(before: newString.firstIndex(of: firstNumber)!)
    
    
    newString = String(newString[...endIndex])
    
    //newString = newString.trimmingCharacters(in: .whitespacesAndNewlines)
    var datesList: [String] = []
    while (newString.firstIndex(of: ",") != nil){
        datesList.append(String(newString[...newString.index(before: newString.firstIndex(of: ",")!)]))
        newString = String(newString[newString.index(after:newString.firstIndex(of: ",")!)...])
    }
    
    return datesList
}

func scrapeClassroom(rawString: String) -> String{
    let firstColon = rawString.firstIndex(of: ":")
    
    var newString = String(rawString[...rawString.index(before: firstColon!)])
    
    return newString
}

