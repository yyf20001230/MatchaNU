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
    
    @State var Number = ""
    @State var Latitude = ""
    @State var Longitude = ""
    @State var ClassOverview = ""
    @State var Instructor = ""
    @State var MeetingInfo = ""
    @State var ClassLocation = ""
    @State var ClassName = ""
    @State var Section = ""
    
    @State private var selectedSection = 0
    @State private var showAlert = false
    @State private var errorMessage = ""
    
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
                            Text("Meeting Location: " + classes.detail[0].MeetingInfo.components(separatedBy: ": ")[0])
                                .foregroundColor(.secondary)
                                .font(.system(.caption2, design: .rounded))
                                .tracking(-0.5)
                            
                            Text("Meeting Info: " + classes.detail[0].MeetingInfo.components(separatedBy: ": ")[1])
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
                
                let elements = self.datas.filter({$0.MeetingInfo.components(separatedBy: ": ")[0].lowercased().contains(self.ClassLocation.lowercased().replacingOccurrences(of:"_", with: ""))})
                
                if !elements.isEmpty{
                    ScrollView(showsIndicators: false){
                        ForEach(elements.prefix(5)){ i in
                            Button(action:{
                                
                            }) {
                                VStack(alignment: .leading) {
                                    Text(i.MeetingInfo)
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
                
                TextField("*Enter course number (e.x. COMP_SCI 349)", text: $Number)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
                Divider()
                
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
                
                TextField("Enter class section", text: $Section)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
                Divider()
                
                TextField("Enter class name", text: $ClassName)
                    .foregroundColor(Color("Default"))
                    .font(.system(.subheadline, design: .rounded))
                
                Divider()
                
                TextField("Finally, comment on your class", text: $ClassOverview)
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
            if selectedSection != 0 {
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
            
            
            Button(action: {
                var geolocation = [(Latitude as NSString).doubleValue, (Longitude as NSString).doubleValue]
                if selectedSection == 0{
                    selectedSection = 1
                    if (geolocation[0] == 0) || (geolocation[1] == 0){
                        geolocation = [-1, -1]
                        showAlert = true
                        Latitude = ""
                        Longitude = ""
                        errorMessage = "Invlalid coordinate. Go to google map to copy your coordinate (be as accurate as possible). \n For now, your class is assumed online."
                    }
                    
                } else if selectedSection == 1{
                    selectedSection = 2
                    if Number.components(separatedBy: " ").count == 3{
                        Number = Number.components(separatedBy: " ").dropLast().joined(separator: "_") + " " + Number.components(separatedBy: " ")[2]
                    } else if Number.components(separatedBy: " ").count > 3 || Number.components(separatedBy: " ").count == 0 || Number.isEmpty{
                        showAlert = true
                        errorMessage = "Your course number contains invalid input! Format it this way: ECON 201 or ELEC_ENG 304 \n Your class will be DEFAULT 0"
                    }
                }
                else {
                    selectedSection = 0
                    if (geolocation[0] > 42.05712) && (geolocation[0] < 42.05851) && (geolocation[1] < -87.67495) && (geolocation[1] > -87.67675){
                        geolocation = [42.05780619999999,-87.67587739999999]
                    } else if (geolocation[0] == 0 || geolocation[1] == 0){
                        geolocation = [-1,-1]
                    }
                    
                    if Number.components(separatedBy: " ").count > 3 || Number.components(separatedBy: " ").count == 0 || Number.isEmpty{
                        Number = "Default 0"
                    }
                    
                    ClassName = (ClassName.isEmpty ? "TBA" : ClassName)
                    MeetingInfo = (MeetingInfo.isEmpty ? "TBA" : MeetingInfo)
                    ClassOverview = (ClassOverview.isEmpty ? "Default overview" : ClassOverview)
                    ClassLocation = (ClassLocation.isEmpty ? "TBA" : ClassLocation)
                    Section = (Section.isEmpty ? "0" : Section)
                    Instructor = (Instructor.isEmpty ? "TBA" : Instructor)
                    
                    classes.userClass.append(ClassInfo(Class: Number.components(separatedBy: " ").dropFirst().joined(separator: " ") + " " + ClassName, ClassLocation: geolocation, ClassOverview: ClassOverview, Instructor: Instructor + " ", Major: Number.components(separatedBy: " ")[0] + " - your Major", MeetingInfo: ClassLocation + ": " + MeetingInfo, School: "", Section: Section + ": your section"))
                    
                    Number = ""
                    Latitude = ""
                    Longitude = ""
                    ClassOverview = ""
                    Instructor = ""
                    MeetingInfo = ""
                    ClassLocation = ""
                    ClassName = ""
                    Section = ""
                    
                    showAlert = true
                    errorMessage = "Your customized class is added!"
                }
                
            }){
                Text((selectedSection == 2) ? "Add Classes!" : "Next!")
                    .font(.system(.subheadline, design: .rounded))
                    .frame(width: 120, height: 40, alignment: .center)
                    .background((selectedSection == 2) ? Color("Theme").opacity(0.7) : Color("ClassColor"))
                    .foregroundColor((selectedSection == 2) ? Color("ClassColor") : Color("Theme"))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text((errorMessage == "Your customized class is added!") ? "Congrats" : "Input Warning"), message: Text("\(errorMessage)"), dismissButton: .default(Text("I understand")))
            })
        }
        
        
        
    }
}


