//
//  EditView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/30/21.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var classes: ClassLocations
    @ObservedObject var notificationManager = NotificationManager()
    @State var datas: [ClassInfo]
    @State var uniqueProf: [ClassInfo]
    
    @State var Latitude = 0.0
    @State var Longitude = 0.0
    @State var MeetingInfo = ""
    
    @State var EditClassLocation = ""
    @State var Instructor = ""
    @State var EditInstructor = ""
    @State var ClassLocation: String
    
    @State private var selectedSection = 0
    @State private var showAlert = false
    @State private var showEditAlert = false
    @State private var selected = false
    @State private var foundLocation = false
    @State private var enteredNextPage = false
    
    
    @State var startTime = Date()
    @State var endTime = Date()
    @State var daysOfWeek = [-1, -1, -1, -1, -1]
    @State var daysBoolean: [Bool] = [false, false, false, false, false]
        
    var body: some View {
        
        let data = datas
        let locations = Array(Set(data.map({$0.MeetingInfo.components(separatedBy: ": ")[0]}))).sorted()
        let profs = Array(Set(data.map({$0.Instructor.replacingOccurrences(of: "|", with: ",").dropLast()}))).sorted()
        let displayDow = ["Mo", "Tu", "We", "Th", "Fr"]
        let finalDowList = ["Mon", "Tues", "Wed", "Thurs", "Fri"]
        let dateFormatter = DateFormatter()
        var finalDow = ""
        var finalString = ""
        
        
        VStack (alignment: .leading){
            if selectedSection == 0{
                
                Text("1. First, let's edit location")
                    .foregroundColor(Color("Theme"))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                
                Divider()
                
                TextField("Enter class location", text: $ClassLocation)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                    .onChange(of: ClassLocation){ value in
                        if !foundLocation{
                            selected = false
                            foundLocation = false
                        }
                        foundLocation = false
                    }
                
                
                let elements = locations.filter({$0.lowercased().contains(ClassLocation.lowercased())})
                
                if !elements.isEmpty && !selected{
                    ScrollView(showsIndicators: false){
                        ForEach(elements.prefix(20), id: \.self){ i in
                            Button(action:{
                                
                                Latitude = data.first(where: {$0.MeetingInfo.contains(i)})!.ClassLocation[0]
                                Longitude = data.first(where: {$0.MeetingInfo.contains(i)})!.ClassLocation[1]
                                
                                MeetingInfo = classes.detail[0].MeetingInfo.components(separatedBy: ": ").dropFirst().joined(separator: " ")
                                Instructor = String(classes.detail[0].Instructor.replacingOccurrences(of: "|", with: ",").dropLast())
                                ClassLocation = i
                                
                                foundLocation = true
                                selected = true
                            }) {
                                VStack(alignment: .leading) {
                                    Text(i)
                                        .foregroundColor(.secondary)
                                        .font(.system(.footnote, design: .rounded))
                                        .fontWeight(.semibold)
                                        .tracking(-0.5)
                                    
                                    
                                }
                                .padding(.vertical)
                                Spacer()
                            }
                            
                        }
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    .padding(.trailing)
                    .frame(height: 160)
                }
                
            } else if selectedSection == 1{

                Text("2. Now, let's edit course info")
                    .foregroundColor(Color("Theme"))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                
                
                
                DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                
                Divider()
                
                DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
                
                Divider()
                
                
                Text("Meeting Time")
                    .foregroundColor(.primary)
                    .tracking(-0.5)
                    .padding(.top, 4)
                    .padding(.bottom)
                    
                HStack{
                    ForEach(0..<5){ i in
                        Button(action: {
                            daysBoolean[i].toggle()
                            for j in 0..<5 {
                                if daysBoolean[j]{
                                    daysOfWeek[j] = i+1
                                }
                                else{
                                    daysOfWeek[j] = -1
                                }
                            }
                        }){
                            Text(displayDow[i])
                                .font(.caption2)
                                .foregroundColor(Color.white)
                                .frame(width: 35, height: 30)
                            
                            
                            
                            
                        }
                        .background(daysBoolean[i] ? Color("Theme") : Color("EditColor"))
                        .cornerRadius(22)
                        
                    }
                    
                    
                }
                
                
                
            } else if selectedSection == 2{
                
                Text("3. Now, let's add your instructor")
                    .foregroundColor(Color("Theme"))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                
                Divider()
                
                TextField("Enter instructor name", text: $Instructor)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                    .onChange(of: Instructor){ value in
                        if !foundLocation{
                            selected = false
                            foundLocation = false
                        }
                        foundLocation = false
                    }
                
                
                let elements = profs.filter({$0.lowercased().contains(Instructor.lowercased())})
                if !elements.isEmpty && !selected {
                    ScrollView(showsIndicators: false){
                        ForEach(elements.prefix(20), id: \.self){ i in
                            Button(action:{
                                foundLocation = true
                                selected = true
                                Instructor = String(i)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(i)
                                        .foregroundColor(.secondary)
                                        .font(.system(.footnote, design: .rounded))
                                        .fontWeight(.semibold)
                                        .tracking(-0.5)
                                        .multilineTextAlignment(.leading)
                                    
                                }
                                .padding(.vertical)
                                Spacer()
                            }
                            
                        }
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    .padding(.trailing)
                    .frame(height: 160)
                }
                
                
            }
            
        }
        .padding(.all)
        .background(Color("ClassColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding(.all)
        
        
        HStack{
            if selectedSection != 0 && selectedSection != 3{
                Button(action: {
                    selectedSection = selectedSection - 1
                    enteredNextPage = false
                    selected = true
                    showAlert = false
                    showEditAlert = false
                }){
                    Text("back")
                        .font(.system(.subheadline, design: .rounded))
                        .frame(width: 80, height: 40, alignment: .center)
                        .background(Color("ClassColor"))
                        .foregroundColor(Color("Red"))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
                }
            }
            
            if selectedSection != 2 && (selected || enteredNextPage){
                Button(action: {
                    enteredNextPage = false
                    selected = true
                    
                    if selectedSection == 0{
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "h:mma"
                        
                        
                        startTime = dateFormatter.date(from: scrapeStartHoursMinutes(rawString: MeetingInfo)) ?? Date()
                        endTime = dateFormatter.date(from: scrapeEndHoursMinutes(rawString: MeetingInfo)) ?? Date()
                        
                        for i in 0..<5{
                            if MeetingInfo.contains(finalDowList[i]){
                                daysOfWeek[i] = i
                                daysBoolean[i] = true
                            }
                            
                        }
                    
                    }
                    
                    
                    var noDow = true
                    for i in 0..<5{
                        if daysBoolean[i]{
                            noDow = false
                        }
                    }
                    if noDow && selectedSection != 0{
                        showAlert = true
                        showEditAlert = true
                    }
                    if !showEditAlert{
                        selectedSection = selectedSection + 1
                        
                    }
                }){
                    Text("next")
                        .font(.system(.subheadline, design: .rounded))
                        .frame(width: 120, height: 40, alignment: .center)
                        .background(Color("ClassColor"))
                        .foregroundColor(Color("Theme"))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
                }
                .alert(isPresented: $showEditAlert, content: {
                    
                    Alert(title: Text("No days of week found"), message: Text("You didn't select days of week for this class, your class meetingInfo will be 'TBA'. Wish to proceed?"), primaryButton: .default(Text("No")),
                     secondaryButton: .destructive(Text("Yes"), action: {
                   selectedSection = selectedSection + 1
                   showEditAlert = false
                   showAlert = false
                    }))})
                
                
            }
            if selectedSection == 2{
                Button(action: {
                    enteredNextPage = false
                    selected = true
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "h:mma"
                    selectedSection = 0
                    
                    let startTimeString = dateFormatter.string(from: startTime)
                    let endTimeString = dateFormatter.string(from: endTime)
                    for i in 0..<5{
                        if daysBoolean[i]{
                            finalDow.append(finalDowList[i])
                            finalDow.append(", ")
                        }
                    }
                    if finalDow.count == 0{
                        finalString = ClassLocation + ": TBA"
                    }   else{
                        finalString = ClassLocation + ": " + finalDow + startTimeString + " - " + endTimeString
                    }
                    
                    
                    
                    if (Latitude > 42.05712) && (Latitude < 42.05851) && (Longitude < -87.67495) && (Longitude > -87.67675){
                        Latitude = 42.0578383
                        Longitude = -87.6761566
                    }
                    
                    MeetingInfo = (MeetingInfo.isEmpty ? classes.detail[0].MeetingInfo.components(separatedBy: ": ").dropFirst().joined(separator: "") : MeetingInfo)
                    ClassLocation = (ClassLocation.isEmpty ? classes.detail[0].MeetingInfo.components(separatedBy: ": ")[0] : ClassLocation)
                    
                    classes.userClass.append(ClassInfo(Class: classes.detail[0].Class, ClassLocation: [Latitude, Longitude], ClassOverview: classes.detail[0].ClassOverview, Instructor: Instructor + " ", Major: classes.detail[0].Major, MeetingInfo: finalString, School: classes.detail[0].School, Section: classes.detail[0].Section))
                    
                    Latitude = 0
                    Longitude = 0
                    Instructor = ""
                    MeetingInfo = ""
                    ClassLocation = ""
                    
                    classes.userClass = classes.userClass.filter{$0 != classes.detail[0]}
                    showAlert = true
                    selectedSection = 2
                    
                }){
                    Text("Submit")
                        .font(.system(.subheadline, design: .rounded))
                        .frame(width: 120, height: 40, alignment: .center)
                        .background(Color("Theme").opacity(0.7))
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
                }
                
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Class Added"), message: Text("Your class is added!"), dismissButton: .default(Text("Yay!")))
                })
                
            }
        }
        
        
    }
    
}




                       
