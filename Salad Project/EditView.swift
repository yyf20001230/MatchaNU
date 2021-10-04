//
//  EditView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/30/21.
//

import SwiftUI

struct EditView: View {
    
    @EnvironmentObject var classes: ClassLocations
    @Binding var datas: [ClassInfo]
    
    @State var Class = ""
    @State var Latitude = 0.0
    @State var Longitude = 0.0
    @State var ClassOverview = ""
    @State var Instructor = ""
    @State var MeetingInfo = ""
    @State var ClassLocation = ""
    @State var ClassName = ""
    @State var Section = ""
    
    @State private var selectedSection = 0
    @State private var showAlert = false
    @State private var selected = false
    
    var body: some View {
        
        if !classes.detail.isEmpty && selectedSection != 0{
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
                
                TextField("Enter class location", text: $ClassLocation)
                    .foregroundColor(Color("Default"))
                    .font(.system(.caption2, design: .rounded))
                    .onChange(of: ClassLocation){ value in
                        if !selected{
                            selected = true
                        }
                    }
                
                let elements = self.datas.filter({$0.MeetingInfo.components(separatedBy: ": ")[0].lowercased().contains(self.ClassLocation.lowercased().replacingOccurrences(of:"_", with: ""))})
                if !elements.isEmpty && self.selected{
                    ScrollView(showsIndicators: false){
                        ForEach(elements.prefix(20)){ i in
                            
                            Button(action:{
                                self.selected = false
                                self.Latitude = i.ClassLocation[0]
                                self.Longitude = i.ClassLocation[1]
                                self.ClassName = i.Class
                                self.Section = i.Section
                                self.MeetingInfo = i.MeetingInfo
                                self.ClassOverview = i.ClassOverview
                                self.ClassLocation = i.MeetingInfo.components(separatedBy: ": ")[0]
                            }) {
                                VStack(alignment: .leading) {
                                    Text(i.MeetingInfo.components(separatedBy: ": ")[0])
                                        .foregroundColor(.secondary)
                                        .font(.system(.caption2, design: .rounded))
                                        .tracking(-0.5)
                                        .multilineTextAlignment(.leading)
                                    
                                }
                                .padding(.all)
                                Spacer()
                            }
                            
                        }
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    .padding(.horizontal)
                    .frame(height: 160)
                }
                
            } else if selectedSection == 1{
                Text("2. Now, let's enter course info")
                    .foregroundColor(Color("Theme"))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                    .padding(.bottom)
                
                TextField("Enter meeting info (e.x. Mon, Tue, 11:00AM - 11:50AM)", text: $MeetingInfo)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
                Divider()
                
                TextField("Enter instructor name", text: $Instructor)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
                
            } else {
                Text("3. Finally, enter some detail")
                    .foregroundColor(Color("Theme"))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .tracking(-0.5)
                    .padding(.bottom)
                
                TextField("Comment on your class", text: $ClassOverview)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
            }
        }
        .padding(.all)
        .background(Color("ClassColor"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding([.horizontal, .bottom])
        
        HStack{
            if selectedSection != 0{
                Button(action: {
                    selectedSection = selectedSection - 1
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
            
            if !selected && !ClassLocation.isEmpty{
                Button(action: {

                    if selectedSection != 2{
                        selectedSection += 1
                    }
                    else {
                        selectedSection = 0
                        if (Latitude > 42.05712) && (Latitude < 42.05851) && (Longitude < -87.67495) && (Longitude > -87.67675){
                            Latitude = 42.0578383
                            Longitude = -87.6761566
                        }
                        
                        MeetingInfo = (MeetingInfo.isEmpty ? "TBA" : MeetingInfo)
                        ClassOverview = (ClassOverview.isEmpty ? "Default overview" : ClassOverview)
                        ClassLocation = (ClassLocation.isEmpty ? "TBA" : ClassLocation)
                        Section = (Section.isEmpty ? "0" : Section)
                        Instructor = (Instructor.isEmpty ? "TBA" : Instructor)
                        
                        classes.userClass.append(ClassInfo(Class: classes.detail[0].Class, ClassLocation: [Latitude, Longitude], ClassOverview: ClassOverview, Instructor: Instructor + " ", Major: classes.detail[0].Major, MeetingInfo: MeetingInfo, School: classes.detail[0].School, Section: Section))
                        
                        Latitude = 0
                        Longitude = 0
                        ClassOverview = ""
                        Instructor = ""
                        MeetingInfo = ""
                        ClassLocation = ""
                        ClassName = ""
                        Section = ""
                        
                        showAlert = true

                    }
                    
                }){
                    Text((selectedSection == 2) ? "Add Classes" : "Next")
                        .font(.system(.subheadline, design: .rounded))
                        .frame(width: 120, height: 40, alignment: .center)
                        .background((selectedSection == 2) ? Color("Theme").opacity(0.7) : Color("ClassColor"))
                        .foregroundColor((selectedSection == 2) ? Color("ClassColor") : Color("Theme"))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Congrats"), message: Text("Your custom class is added"), dismissButton: .default(Text("Yay!")))
                })
            }
           
        }
        
        
        
    }
}


