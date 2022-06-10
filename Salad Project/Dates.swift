
import Foundation
import SwiftUI
import CryptoKit
import MapKit
//TESTING
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

//Turns valid date string into Date object
func newDate(inString: String) -> Date{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mma"
    dateFormatter.locale = Locale(identifier: "en_US")
    
    
    guard let new_date = dateFormatter.date(from: inString) else { return (dateFormatter.date(from: "00:00AM")!) }
    
    
    return new_date
}

func timeInterval (currentHour: Int, currentMinute: Int, classHour: Int, classMinute: Int)-> Int{
    let currentTime = currentHour * 60 + currentMinute
    let classTime = classHour * 60 + classMinute
    return classTime - currentTime
}

func timeWithDelay(timeList: [Int], delay: Int) -> [Int]{
    var newList: [Int] = []
    if (delay > timeList[1]){
        newList.append(timeList[0] - 1)
        newList.append(timeList[1] + 60)
        newList[1] -= delay
    }
    else{
        newList.append(timeList[0])
        newList.append(timeList[1] - delay)
    }
    
    return newList
    
}

func separateHourMinute(scrapedString: String) -> [Int]{
    if scrapedString.contains("TBA"){
        return [-1,-1]
    }
    
    if !scrapedString.contains("PM") && !scrapedString.contains("AM"){
        return [-1,-1]
    }
    
    var timeList: [Int] = []
    
    var firstLetter: Character = "Z"
    for char in scrapedString{
        if char.isLetter{
            firstLetter = char
            break
        }
    }
    let firstLetterIndex = scrapedString.firstIndex(of: firstLetter)
    
    var hour =  String(scrapedString[...scrapedString.index(before: scrapedString.firstIndex(of: ":")!)]).trimmingCharacters(in: .whitespacesAndNewlines)
    
    let minute = String(scrapedString[scrapedString.index(after: scrapedString.firstIndex(of: ":")!)...scrapedString.index(before: firstLetterIndex!)]).trimmingCharacters(in: .whitespacesAndNewlines)
    
    if hour.first == "0"{
        hour = String(hour.dropFirst(1))
    }
    
    var hour_int: Int = Int(hour) ?? -1
    let minute_int: Int = Int(minute) ?? -1
    
    
    if firstLetter == "P"{
        if hour_int == 12{
            hour_int += 0
        }
        else{
            hour_int += 12
        }
    }
    
    timeList.append(hour_int)
    timeList.append(minute_int)
    
    return timeList
}

//scrape helper
func getTime(rawString: String) -> String{
    
    let newString: String
    newString = rawString.contains(",") ? rawString.components(separatedBy: ",").last! : ""
    return newString
    
}

//Get start time from Non-TBA MeetingInfo
func scrapeStartHoursMinutes(rawString: String) -> String{
    let newString = getTime(rawString: rawString)
    let finalString = (newString == "" || !newString.contains("-")) ? "TBA" : newString.components(separatedBy: "-")[0]
    return finalString
}


//Get end time from Non-TBA MeetingInfo
func scrapeEndHoursMinutes(rawString: String) -> String{
    let newString = getTime(rawString: rawString)
    let finalString = (newString == "" || !newString.contains("-")) ? "TBA" : newString.components(separatedBy: "-")[1]
    return finalString
}

//Get list of dates in week from Non-TBA MeetingInfo

func scrapeDatesOfWeek(rawString: String) -> [String] {
    let startIndex = rawString.index(after: rawString.firstIndex(of: ":")!)
    var newString = String(rawString[startIndex...])
    let validList = ["mo","tu","we","th","fr"]
    var isValid: Bool = false
        
    for str in validList{
        if newString.lowercased().contains(str){
            isValid = true
        }
    }
    
    if !isValid || rawString == ""{
        return []
    }
    var firstNumber: Character = "Z"
    for char in newString{
        if char.isNumber{
            firstNumber = char
            break
        }
    }
    let endIndex = newString.index(before: newString.firstIndex(of: firstNumber) ?? newString.endIndex)
    
    
    newString = String(newString[...endIndex])
    var datesList: [String] = []
    while (newString.firstIndex(of: ",") != nil){
        datesList.append(String(newString[...newString.index(before: newString.firstIndex(of: ",")!)]))
        newString = String(newString[newString.index(after:newString.firstIndex(of: ",")!)...])
    }
    return datesList
}

func switchDaysWithInt(dowList: [String]) -> [Int]{
    var intList:[Int] = []
    let switchDict = [
                      "mo": 2,
                      "tu": 3,
                      "we": 4,
                      "th": 5,
                      "fr": 6]
    for dow in dowList{
        var inString = dow
        inString = String(inString.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).prefix(2))
        intList.append(switchDict[inString] ?? -1)
    }
    
    return intList
}

func scrapeClassroom(rawString: String) -> String{
    let firstColon = rawString.firstIndex(of: ":")
    let newString = String(rawString[...rawString.index(before: firstColon!)])
    
    return newString
}

func ConflictClass(start: Int, end: Int, date: Int, allClasses: [ClassInfo]) -> [Int]{
    var ClassList: [[Int]] = []

    for classes in allClasses{
        let weekdays = switchDaysWithInt(dowList: scrapeDatesOfWeek(rawString: classes.MeetingInfo))
        let startTime = separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: classes.MeetingInfo))
        let endTime = separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: classes.MeetingInfo))
        
        if startTime != [-1,-1] && endTime != [-1,-1] && !weekdays.contains(-1){
            let startTime = startTime[0] * 60 + startTime[1]
            let endTime = endTime[0] * 60 + endTime[1]
            for dow in weekdays{
                if dow == date{
                    ClassList.append([startTime, endTime])
                }
            }
        }
    }
    
    
    print(ClassList.sorted(by: {$0.first! < $1.first!}))

    return [0,0]
}



