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
                        .foregroundColor(.secondary)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                    
                    VStack(alignment: .leading, spacing: 4.0){
                        HStack{
                            Text("Meeting Location: " + classes.detail[0].MeetingInfo.components(separatedBy: ": ")[0])
                                .foregroundColor(.secondary)
                                .font(.system(.caption2, design: .rounded))
                                .tracking(-0.5)
                            Spacer()
                        }
                        
                        Text("Meeting Info: " + classes.detail[0].MeetingInfo.components(separatedBy: ": ")[1])
                            .foregroundColor(.secondary)
                            .font(.system(.caption2, design: .rounded))
                            .tracking(-0.5)
                        Text("Instructor: " + classes.detail[0].Instructor.replacingOccurrences(of: "|", with: ",").dropLast())
                            .foregroundColor(.secondary)
                            .font(.system(.caption2, design: .rounded))
                            .tracking(-0.5)
                    }
                    .frame(width: UIScreen.main.bounds.width / 1.3)
                    .padding(.all)
                    .background(Color("ClassColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding([.leading,.bottom])
                    
                    
                    Text("Actions")
                        .foregroundColor(.secondary)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                    
                    
                    HStack{
                        Button(action: {
                            
                            if classes.detail[0].ClassLocation[0] == -1 && classes.detail[0].ClassLocation[1] == -1{
                                self.showNavigationAlert = true
                            } else {
                                classes.ShowClass = false
                                classes.showRoute.toggle()
                            }
                        }){
                            VStack{
                                Image(systemName: "mappin.circle.fill")
                                    .padding(.top)
                                    .padding(.horizontal, 24)
                                    .scaleEffect(1.5)
                                    .scaledToFill()
                                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                Text(classes.showRoute ? "Stop" : "Route")
                                    .padding(.all)
                                    .font(.system(.caption2, design: .rounded))
                            }
                            
                            .accentColor(self.classes.showRoute ? Color(#colorLiteral(red: 0.9176470588, green: 0.3450980392, blue: 0.3019607843, alpha: 1)) : Color("Theme"))
                            .frame(width: UIScreen.main.bounds.width / 5.1)
                            .background(Color("ClassColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .alert(isPresented: $showNavigationAlert, content: {
                            let message = classes.detail[0].Major.components(separatedBy: " ")[0] + " " + classes.detail[0].Class.components(separatedBy: " ")[0]
                            return Alert(title: Text("No location found"), message: Text(message + "-" + classes.detail[0].Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: "") + " is either online or its location is not determined yet or located outside of Evanston Campus"), dismissButton: .default(Text("Got it!")))
                        })
                        
                        
                        
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
                                    .padding(.all)
                                    .font(.system(.caption2, design: .rounded))
                            }
                            .accentColor(classes.userClass.contains(classes.detail[0]) ? Color(#colorLiteral(red: 0.9176470588, green: 0.3450980392, blue: 0.3019607843, alpha: 1)) : Color("Theme"))
                            .frame(width: UIScreen.main.bounds.width / 5.1)
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
                                    .padding(.all)
                                    .font(.system(.caption2, design: .rounded))
                            }
                            .accentColor(Color("Theme"))
                            .frame(width: UIScreen.main.bounds.width / 5.1)
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
                                        .padding(.all)
                                        .font(.system(.caption2, design: .rounded))
                                }
                                .accentColor(Color("Theme"))
                                .frame(width: UIScreen.main.bounds.width / 5.1)
                                .background(Color("ClassColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            })
                        }
                        
                        
                    }
                    .padding([.leading,.bottom])
                    
                    
                    Text("Class Overview")
                        .foregroundColor(.secondary)
                        .font(.system(.subheadline, design: .rounded))
                        .tracking(-0.5)
                        .padding(.leading)
                    
                    
                    
                    if !self.classes.detail.isEmpty{
                        HStack{
                            VStack(alignment: .leading){
                                Text(self.classes.detail[0].ClassOverview)
                                    .foregroundColor(.secondary)
                                    .font(.system(.caption2, design: .rounded))
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





