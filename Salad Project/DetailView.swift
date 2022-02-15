//
//  DetailView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/22/21.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @EnvironmentObject var classes: ClassLocations
    @EnvironmentObject var settings: appSettings
    @State private var showAlert = false
    @State private var showNavigationAlert = false
    
    var body: some View {
        if !self.classes.detail.isEmpty{
            ScrollView (showsIndicators: false){
                VStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 10)
                        .foregroundColor(Color("SearchBarColor"))
                    
                    Text("Class Info")
                        .fontWeight(.bold)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 4.0){
                        HStack{
                            Text(classes.detail[0].MeetingInfo.contains(": ") ? "Location: " + classes.detail[0].MeetingInfo.components(separatedBy: ": ")[0] : "Location: TBA")
                                .foregroundColor(.secondary)
                                .font(.system(.caption, design: .rounded))
                                .fontWeight(.semibold)
                                .tracking(-0.5)
                            Spacer()
                        }
                        Text(classes.detail[0].MeetingInfo.contains(": ") ? "Info: " + classes.detail[0].MeetingInfo.components(separatedBy: ": ")[1] : "Info: TBA")
                            .foregroundColor(.secondary)
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.semibold)
                            .tracking(-0.5)
                        Text("Instructor: " + classes.detail[0].Instructor.replacingOccurrences(of: "|", with: ",").dropLast())
                            .foregroundColor(.secondary)
                            .font(.system(.caption, design: .rounded))
                            .fontWeight(.semibold)
                            .tracking(-0.5)
                    }
                    .frame(width: UIScreen.main.bounds.width / 1.3)
                    .padding(.all)
                    .background(Color("ClassColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding([.leading,.bottom])
                    
                    
                    Text("Routing")
                        .fontWeight(.bold)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                        
                    
                    Button(action: {
                        if classes.detail[0].ClassLocation[0] == -1 || classes.detail[0].ClassLocation[1] == -1{
                            self.showNavigationAlert = true
                        } else {
                            classes.ShowClass = false
                            classes.showRoute.toggle()
                            settings.Schedule = false
                        }
                    }){
                        
                        HStack(alignment: .center){
                            
                            
                            Image(systemName: "mappin.circle.fill")
                                .padding(.horizontal, 16)
                                .scaleEffect(1.5)
                                .scaledToFill()
                                .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                            
                            if settings.Schedule{
                                Text("Navigate")
                                    .foregroundColor(.secondary)
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.bold)
                                    .padding(.all)
                            } else {
                                VStack (alignment: .leading, spacing: 3.0){
                                    Text("Navigate:")
                                        .foregroundColor(.secondary)
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.bold)
                                        .padding([.horizontal, .top])
                                    
                                    if classes.detail[0].ClassLocation[0] != -1 && classes.detail[0].ClassLocation[0] != -1{
                                        Text(String(classes.Time) + " mins by walking")
                                            .font(.system(.footnote, design: .rounded))
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.leading)
                                            .padding([.horizontal,.bottom])
                                    } else {
                                        Text("Location unknown")
                                            .font(.system(.footnote, design: .rounded))
                                            .fontWeight(.semibold)
                                            .multilineTextAlignment(.leading)
                                            .padding([.horizontal, .bottom])
                                    }
                            }
                            
                            }
                            
                            
                            
                            
                        }
                        
                        .accentColor(self.classes.showRoute ? Color("Red") : Color("Theme"))
                        .frame(width: UIScreen.main.bounds.width / 1.3, height: UIScreen.main.bounds.height * 0.08)
                        .padding(.horizontal)
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.leading)
                    }
                    .alert(isPresented: $showNavigationAlert, content: {
                        let message = classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0]
                        return Alert(title: Text("No location found"), message: Text(message + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "") + " is either online or its location is not determined yet or located outside of Evanston Campus"), dismissButton: .default(Text("Got it!")))
                    })
                    .padding(.bottom)
                    

                    Text("Actions")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                    

                    HStack{
                        Button(action: {
                            if classes.userClass.contains(classes.detail[0]){
                                classes.userClass = classes.userClass.filter{$0 != classes.detail[0]}
                                self.showAlert = true
                            } else{
                                classes.userClass.append(self.classes.detail[0])
                                self.showAlert = true
                            }
                        }){
                            VStack{
                                Image(systemName: "plus.circle.fill")
                                    .rotationEffect(classes.userClass.contains(classes.detail[0]) ? Angle(degrees: 45) : Angle(degrees: 0))
                                    .padding(.top)
                                    .padding(.horizontal, 24)
                                    .scaleEffect(1.5)
                                    .scaledToFill()
                                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                Text(classes.userClass.contains(classes.detail[0]) ? "Drop" : "Add")
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.semibold)
                                    .padding(.all)
                            }
                            .accentColor(classes.userClass.contains(classes.detail[0]) ? Color("Red") : Color("Theme"))
                            .frame(width: UIScreen.main.bounds.width / 3.7)
                            .background(Color("ClassColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                        }
                        .alert(isPresented: $showAlert, content: {
                            let message = classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0]
                            return Alert(title: Text(classes.userClass.contains(classes.detail[0]) ? "Class Added" : "Class Dropped"), message: Text(classes.userClass.contains(classes.detail[0]) ? message + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "") + " is added to your schedule" : message + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "") + " is dropped out of your schedule"), dismissButton: .default(Text("Got it!")))
                        })
                        
                        Button(action: {
                            classes.EditClass = true
                            classes.Section.removeAll()
                            classes.Section.append(classes.detail[0])
                        }){
                            VStack{
                                Image(systemName: "pencil.circle.fill")
                                    .padding(.top)
                                    .padding(.horizontal, 24)
                                    .scaleEffect(1.5)
                                    .scaledToFill()
                                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                Text("Edit")
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.semibold)
                                    .padding(.all)
                            }
                            .accentColor(Color("Theme"))
                            .frame(width: UIScreen.main.bounds.width / 3.7)
                            .background(Color("ClassColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                        }
                        
                        
                        
                        if self.classes.detail[0].ClassLocation == [42.0578383,-87.6761566]{
                            Link(destination: URL(string: "https://www.mccormick.northwestern.edu/contact/tech-room-finder.html")!, label: {
                                VStack{
                                    Image(systemName: "viewfinder.circle.fill")
                                        .padding(.top)
                                        .padding(.horizontal, 16)
                                        .scaleEffect(1.5)
                                        .scaledToFill()
                                        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                    Text("Finder")
                                        .font(.system(.footnote, design: .rounded))
                                        .fontWeight(.semibold)
                                        .padding(.all)
                                        
                                }
                                .accentColor(Color("Theme"))
                                .frame(width: UIScreen.main.bounds.width / 3.7)
                                .background(Color("ClassColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                        }
                        
                        
                    }
                    .padding([.leading,.bottom])
                    
                    
                    Text("Class Overview")
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                    
                    
                    
                    if !self.classes.detail.isEmpty{
                        HStack{
                            VStack(alignment: .leading){
                                Text(self.classes.detail[0].ClassOverview)
                                    .foregroundColor(.secondary)
                                    .font(.system(.caption, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tracking(-0.5)
                                    .lineSpacing(4)
                                
                            }
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width / 1.3)
                        .padding(.all)
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding([.leading,.bottom])
                        
                    }
                    
                    Rectangle()
                        .frame(height: 150)
                        .foregroundColor(Color("SearchbarColor"))
                }
                .padding(.leading)
            }
        }
        
        
    }
}





