
import Foundation
import SwiftUI
import CryptoKit
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

func hasConflict(allClasses: [ClassInfo]) -> [Any]{
    //First, take the class infos and convert them into an array of [startTime, endTime]
    var timesList = [[ClassInfo:[Int]](),[ClassInfo:[Int]](),[ClassInfo:[Int]](),[ClassInfo:[Int]](),[ClassInfo:[Int]]()]
    //timesList is formatted as:
        //Each row represents a day from Mon to Fri
        //In each row, each entry is a tuple of [startTime,endTime]
    for classes in allClasses{
        let startTimeString = scrapeStartHoursMinutes(rawString: classes.MeetingInfo)
        let endTimeString = scrapeEndHoursMinutes(rawString: classes.MeetingInfo)
        
        if startTimeString != "TBA" && endTimeString != "TBA"{
            let startTimeInt = Int(newDate(inString: startTimeString).timeIntervalSince1970)
            let endTimeInt = Int(newDate(inString: endTimeString).timeIntervalSince1970)
            let dows = switchDaysWithInt(dowList: scrapeDatesOfWeek(rawString: classes.MeetingInfo))
            //Indexing can be done as dow - 2, since monday starts at 2
            if !dows.contains(-1){
                for dow in dows{
                    timesList[dow-2][classes] = [startTimeInt, endTimeInt]
                }
            }
        }
    }
    
//    let dict = Dictionary(timesList[0].sorted(by: {
//        $0.value[0] < $1.value[0]
//    }))
//    timesList[0] = dict
//        
//        
//    
//    print(timesList)
    
    //1. Need to have a count for how many conflict, not just whether there is conflict
        //Count is used to detemrine the scale factor for the width
    //2. Optional: Might also need to know which class is the one that causes the conflict
        //might not need it, because rendering is done in scheduleview.
    
    
//    #If there is a single overlap, then we know to return false.
//            #The way we would know is if in any meeting, the end time is larger than the start time of the iterated meeting
//            #If we sort the intervals by start time first, then we can check if each meeting ends before the next one starts

//            intervals.sort()
//            for i in range(len(intervals)-1):
//                if intervals[i][1] > intervals[i+1][0]:
//                    return False
//            return True
    return timesList
}



