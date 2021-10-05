//
//  EditView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/30/21.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var classes: ClassLocations
    @State var datas: [ClassInfo]
    @State var uniqueProf: [ClassInfo]
    
    @State var Latitude = 0.0
    @State var Longitude = 0.0
    @State var MeetingInfo = ""
    
    @State var ClassLocation = ""
    @State var EditClassLocation = ""
    @State var Instructor = ""
    @State var EditInstructor = ""

    
    @State private var selectedSection = 0
    @State private var showAlert = false
    @State private var selected = false
    @State private var foundLocation = false
    @State private var enteredNextPage = false
    var body: some View {
        
        let data = datas
        let locations = Array(Set(data.map({$0.MeetingInfo.components(separatedBy: ": ")[0]})))
        let profs = Array(Set(data.map({$0.Instructor.replacingOccurrences(of: "|", with: ",").dropLast()})))
        
        if !classes.detail.isEmpty && selectedSection == 2{
            VStack (alignment: .leading, spacing: 10){
                
                    HStack{
                        Text(classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0] + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: ""))
                            .foregroundColor(.primary)
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.bold)
                            .tracking(-0.5)
                        Spacer()
                    }
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 4.0){
                            Text("Meeting Location: " + MeetingInfo.components(separatedBy: ": ")[0])
                                .foregroundColor(.secondary)
                                .font(.system(.caption2, design: .rounded))
                                .tracking(-0.5)
                            
                            Text("Meeting Info: " + MeetingInfo.components(separatedBy: ": ")[1])
                                .foregroundColor(.secondary)
                                .font(.system(.caption2, design: .rounded))
                                .tracking(-0.5)
                            
                            Text("Instructor: " + classes.detail[0].Instructor.replacingOccurrences(of: "|", with: ",").dropLast())
                                .foregroundColor(.secondary)
                                .font(.system(.caption2, design: .rounded))
                                .tracking(-0.5)
                        }
                        
                        Spacer()
                        
                    }
                
            }
            .padding(.all)
            .background(Color("ClassColor"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.all)
        }
        
       
            
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
                                foundLocation = true
                                MeetingInfo = classes.detail[0].MeetingInfo.components(separatedBy: ": ").dropFirst().joined(separator: " ")
                                ClassLocation = i
                                selected = true
                            }) {
                                VStack(alignment: .leading) {
                                    Text(i)
                                        .foregroundColor(.secondary)
                                        .font(.system(.caption2, design: .rounded))
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
                
            } else if selectedSection == 1{
                Text("2. Now, let's edit course info")
                    .foregroundColor(Color("Theme"))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                
                Divider()
                
                TextField("Meeting time (Tue, 11:00AM - 11:50AM)", text: $MeetingInfo)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                    
                
                Divider()
                
                TextField("Enter instructor name", text: $Instructor)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
                let elements = profs.filter({$0.lowercased().contains(Instructor.lowercased())})
                if !elements.isEmpty{
                    ScrollView(showsIndicators: false){
                        ForEach(elements.prefix(20), id: \.self){ i in
                            Button(action:{
                                Instructor = String(i)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(i)
                                        .foregroundColor(.secondary)
                                        .font(.system(.caption2, design: .rounded))
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
            if selectedSection != 0{
                Button(action: {
                    selectedSection = selectedSection - 1
                    enteredNextPage = false
                
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
            
            if selected || enteredNextPage{
                Button(action: {
                    enteredNextPage = true
                    if selectedSection != 1{
                        selectedSection += 1
                        
                        selected = false
                    }
                    else {
                        selectedSection = 0
                        
                        if (Latitude > 42.05712) && (Latitude < 42.05851) && (Longitude < -87.67495) && (Longitude > -87.67675){
                            Latitude = 42.0578383
                            Longitude = -87.6761566
                        }
                        
                        MeetingInfo = (MeetingInfo.isEmpty ? classes.detail[0].MeetingInfo.components(separatedBy: ": ").dropFirst().joined(separator: "") : MeetingInfo)
                        ClassLocation = (ClassLocation.isEmpty ? classes.detail[0].MeetingInfo.components(separatedBy: ": ")[0] : ClassLocation)
                        
                        classes.userClass.append(ClassInfo(Class: classes.detail[0].Class, ClassLocation: [Latitude, Longitude], ClassOverview: classes.detail[0].ClassOverview, Instructor: Instructor + " ", Major: classes.detail[0].Major, MeetingInfo: ClassLocation + ": " + MeetingInfo, School: classes.detail[0].School, Section: classes.detail[0].Section))
                        
                        Latitude = 0
                        Longitude = 0
                        Instructor = ""
                        MeetingInfo = ""
                        ClassLocation = ""
                        showAlert = true
                        
                        classes.userClass = classes.userClass.filter{$0 != classes.detail[0]}
                        classes.detail.removeAll()
                    }
                    
                }){
                    Text((selectedSection == 1) ? "Add Classes" : "Next")
                        .font(.system(.subheadline, design: .rounded))
                        .frame(width: 120, height: 40, alignment: .center)
                        .background((selectedSection == 1) ? Color("Theme").opacity(0.7) : Color("ClassColor"))
                        .foregroundColor((selectedSection == 1) ? Color("ClassColor") : Color("Theme"))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Congrats"), message: Text("Your custom class is edited"), dismissButton: .default(Text("Yay!")))
                })
            }
           
        }
        
        
        
    }
}


