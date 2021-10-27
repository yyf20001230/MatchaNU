
import Foundation
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

    /*
    var outputString = ""
    let list = separateHourMinute(scrapedString: startString)
    for num in list{
        outputString.append(String(num))
        outputString.append(" ")
    }
    
    var dowString = ""
    let dowList = switchDaysWithInt(dowList: datesList)
    for dow in dowList{
        dowString = dowString + String(dow)
    }
    
    return outputString + "\n" + dowString
    */
}

//    func allTimes(startTime: Date, endTime:Date, classroom: String) -> MeetingTimes{
//        return MeetingTimes{startTime: startTime, endTime: endTime, classroom: classroom}
//
//    }

//Turns valid date string into Date object
func newDate(inString: String) -> Date{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mma"
    dateFormatter.locale = Locale(identifier: "en_US")
    
    
    guard let new_date = dateFormatter.date(from: inString) else { return (dateFormatter.date(from: "00:00AM")!) }
    
    
    return new_date
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

    var newString: String
    let lastComma = rawString.lastIndex(of: ",") ?? rawString.startIndex
    newString = String(rawString[rawString.index(after: lastComma)...])
    return newString
}

//Get start time from Non-TBA MeetingInfo
func scrapeStartHoursMinutes(rawString: String) -> String{
    let newString = getTime(rawString: rawString)
    var firstLetter: Character = "Z"
    for char in newString{
        if char.isLetter{
            firstLetter = char
            break
        }
    }
    let firstLetterIndex = newString.firstIndex(of: firstLetter)
    if (firstLetterIndex == nil){
        return "TBA"
    }
         
    let finalString = String(newString[...newString.index(after: firstLetterIndex!)])
    
    //finalString = finalString +  String(newString[firstLetterIndex!...newString.index(after: firstLetterIndex!)])
    return finalString
}


//Get end time from Non-TBA MeetingInfo
func scrapeEndHoursMinutes(rawString: String) -> String{
    var newString = getTime(rawString: rawString)
    let hyphenIndex = newString.firstIndex(of: "-")
    newString = String(newString[newString.index(after: hyphenIndex!)...])
    
    
    let finalString = String(newString)
    
    //finalString = finalString + String(newString[firstLetterIndex!...])
    return finalString
}

//Get list of dates in week from Non-TBA MeetingInfo

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

func switchDaysWithInt(dowList: [String]) -> [Int]{
    var intList:[Int] = []
    let switchDict = ["su": 1,
                      "mo": 2,
                      "tu": 3,
                      "we": 4,
                      "th": 5,
                      "fr": 6,
                      "sa": 7]
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
