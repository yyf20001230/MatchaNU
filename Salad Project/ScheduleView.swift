//
//  ScheduleView.swift
//  ClassFinder
//
//  Created by Kevin Su on 27/8/2021.
//

import SwiftUI
import CryptoKit

struct ScheduleView: View {
    
    @State var date = Date()
    @State var calendar = Calendar.current
    @State var height = CGFloat(UIScreen.main.bounds.height)
    @State var width =  CGFloat(UIScreen.main.bounds.width)
    @State var timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: appSettings
    @EnvironmentObject var classes: ClassLocations
    
    
    var body: some View {
        let hourDistance = CGFloat(height * 0.70 / CGFloat(classes.endTime - classes.startTime))
        var day = calendar.component(.weekday, from: date)
        var hour = calendar.component(.hour, from: date)
        var minute = calendar.component(.minute, from: date)
        
        VStack{
            HStack (spacing: 0){
                Text("Mon")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(day == 2 && settings.timeline ? Color.white : .secondary)
                    .frame(width: width * 0.175, alignment: .center)
                    .background(day == 2 && settings.timeline ? Color.red.opacity(0.5) : colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Tue")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(day == 3 && settings.timeline ? Color.white : .secondary)
                    .frame(width: width * 0.175, alignment: .center)
                    .background(day == 3 && settings.timeline ? Color.red.opacity(0.5) : colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Wed")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(day == 4 && settings.timeline ? Color.white : .secondary)
                    .frame(width: width * 0.175, alignment: .center)
                    .background(day == 4 && settings.timeline ? Color.red.opacity(0.5) : colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Thu")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(day == 5 && settings.timeline ? Color.white : .secondary)
                    .frame(width: width * 0.175, alignment: .center)
                    .background(day == 5 && settings.timeline ? Color.red.opacity(0.5) : colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Fri")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(day == 6 && settings.timeline ? Color.white : .secondary)
                    .frame(width: width * 0.175, alignment: .center)
                    .background(day == 6 && settings.timeline ? Color.red.opacity(0.5) : colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.leading, width * 0.08)
            .padding(.top, height * 0.08)
            
            ScrollView (showsIndicators: false){
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0){
                        ForEach(classes.startTime..<classes.endTime + 1, id: \.self){ i in
                            HStack(alignment: .center){
                                Text(i < 12 ? String(i) : i != 12 ? String(i - 12): String(12))
                                    .foregroundColor(.secondary)
                                    .font(.system(.caption2, design: .rounded))
                                    .frame(width: width * 0.08, height: hourDistance)
                                
                                Rectangle()
                                    .fill(Color("EditColor").opacity(0.5))
                                    .frame(width: width * 0.85, height: 1)
                                
                            }
                            .padding(.leading, width * 0.01)
                            
                        }
                    }
                    
                    Double(hour) + Double(minute / 60) < Double(classes.endTime) + 0.5 && Double(hour) + Double(minute / 60) > Double(classes.startTime) - 0.5 &&  settings.timeline ?
                    HStack{
                        Text(minute > 5 && minute < 55 ? (hour < 12 ? String(hour) : String(hour - 12)) + ":" + (minute > 9 ? String(minute) : "0" + String(minute)) : "")
                            .onReceive(timer){ _ in
                                date = Date()
                                calendar = Calendar.current
                                day = calendar.component(.weekday, from: date)
                                hour = calendar.component(.hour, from: date)
                                minute = calendar.component(.minute, from: date)
                            }
                            .frame(width: width * 0.08, height: hourDistance)
                            .foregroundColor(Color.red.opacity(0.7))
                            .font(.system(.caption2, design: .rounded))
                        
                        
                        Rectangle()
                            .fill(Color.red.opacity(0.7))
                            .frame(width: width * 0.85, height: 2)
                            .opacity(0.5)
                        
                    }
                    .padding(.leading, width * 0.01)
                    .offset(y: CGFloat(hour - classes.startTime) * hourDistance)
                    .offset(y: CGFloat(minute) / 60 * hourDistance)
                    
                    : nil
                    
                    
                    let myBool = classes.detail.isEmpty ? hasConflict(allClasses: classes.userClass) : hasConflict(allClasses: classes.userClass + classes.detail)
                    
                    let dow = !classes.detail.isEmpty && classes.detail[0].MeetingInfo.contains(": ") ? switchDaysWithInt(dowList: scrapeDatesOfWeek(rawString: classes.detail[0].MeetingInfo)) : []
                    ForEach(dow, id: \.self){ weekday in
                        let start = separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: classes.detail[0].MeetingInfo))
                        let end = separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: classes.detail[0].MeetingInfo))
                        let startHour = start[0]
                        let startMinute = start[1]
                        let endHour = end[0]
                        let endMinute = end[1]
                        if startHour != -1 && startMinute != -1 && endHour != -1 && endMinute != -1 && !dow.contains(-1){
                            ZStack (alignment: .center){
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color("EditColor"), lineWidth: 2)
                                
                                Text(classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: "-")[0])
                                    .font(.system(.caption2, design: .rounded))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("EditColor"))
                                    .multilineTextAlignment(.center)
                            }
                            
                            .frame(width: width * 0.16, height: (CGFloat(endHour - startHour) + CGFloat(endMinute - startMinute) / 60) * hourDistance)
                            .position(x: width * 0.19 + CGFloat(weekday - 2) * width * 0.175, y: CGFloat(startHour - classes.startTime) * hourDistance + CGFloat(startMinute) * hourDistance / 60 + hourDistance / 2 + (CGFloat(endHour - startHour) + CGFloat(endMinute - startMinute) / 60) * hourDistance / 2)
                            
                        }
                    }
                    
                    
                    ForEach(classes.userClass, id: \.self){classInfo in
                        if classInfo.MeetingInfo.contains(": "){
                            let dow = switchDaysWithInt(dowList: scrapeDatesOfWeek(rawString: classInfo.MeetingInfo))

                            ForEach(dow, id: \.self){ weekday in
                                let start = separateHourMinute(scrapedString: scrapeStartHoursMinutes(rawString: classInfo.MeetingInfo))
                                let end = separateHourMinute(scrapedString: scrapeEndHoursMinutes(rawString: classInfo.MeetingInfo))
                                let startHour = start[0]
                                let startMinute = start[1]
                                let endHour = end[0]
                                let endMinute = end[1]
                                
                                
                                if startHour != -1 && startMinute != -1 && endHour != -1 && endMinute != -1 && !dow.contains(-1){
                                    let inputData = Data(classInfo.Class.utf8)
                                    let hashed = SHA256.hash(data: inputData)
                                    let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
                                    let hashNumber = hashString.filter({$0.isNumber})
                                    let coloring = hashNumber.compactMap{$0.wholeNumberValue}.reduce(0, +) % 12 + 1
                                    
                                    ZStack (alignment: .center){
                                        Rectangle()
                                            .fill(Color(String(coloring)))
                                            .cornerRadius(5)
                                        //.shadow(color: Color.black.opacity(0.08), radius: 5, x: 5, y: 5)
                                        
                                        Text(classInfo.Major.components(separatedBy: " ")[0] + " " + classInfo.Class.components(separatedBy: "-")[0])
                                            .font(.system(.caption2, design: .rounded))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(String(coloring)).opacity(0.8))
                                            .environment(\.colorScheme, colorScheme == .dark ? .light : .dark)
                                            .multilineTextAlignment(.center)
                                    }
                                    .opacity(settings.hidePastEvent && (weekday * 24 + endHour + endMinute / 60 < day * 24 + hour + minute / 60) ? 0.2 : 1)
                                    .frame(width: width * 0.16, height: (CGFloat(endHour - startHour) + CGFloat(endMinute - startMinute) / 60) * hourDistance)
                                    .position(x: width * 0.19 + CGFloat(weekday - 2) * width * 0.175, y: CGFloat(startHour - classes.startTime) * hourDistance + CGFloat(startMinute) * hourDistance / 60 + hourDistance / 2 + (CGFloat(endHour - startHour) + CGFloat(endMinute - startMinute) / 60) * hourDistance / 2)
                                    .onTapGesture(perform: {
                                        classes.detail.removeAll()
                                        classes.detail.append(classInfo)
                                        classes.ShowClass = true
                                    })
                                }
                            }
                        }
                    }
                    
                }
                .frame(width: .infinity)
            }
            .frame(width: .infinity)
            .frame(height: height * 0.70)
            
            .ignoresSafeArea()
            
            Spacer()
            
        }
        .ignoresSafeArea()
        
        
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
