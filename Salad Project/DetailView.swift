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
                            classes.showRoute.toggle()
                        }){
                            VStack{
                                Image(systemName: "mappin.circle.fill")
                                    .padding(.top)
                                    .padding(.horizontal, 24)
                                    .scaleEffect(1.5)
                                    .scaledToFill()
                                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                Text(classes.showRoute ? "Stop" : "Navigate")
                                    .padding(.all)
                                    .font(.system(.caption2, design: .rounded))
                            }
                            
                            .accentColor(self.classes.showRoute ? Color(#colorLiteral(red: 0.9176470588, green: 0.3450980392, blue: 0.3019607843, alpha: 1)) : Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .frame(width: 100)
                            .background(Color("ClassColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        
                        
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
                                Text(classes.userClass.contains(classes.detail[0]) ? "DROP" : "ADD")
                                    .padding(.all)
                                    .font(.system(.caption2, design: .rounded))
                            }
                            .accentColor(classes.userClass.contains(classes.detail[0]) ? Color(#colorLiteral(red: 0.9176470588, green: 0.3450980392, blue: 0.3019607843, alpha: 1)) : Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                            .frame(width: 100)
                            .background(Color("ClassColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                        }
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text(classes.userClass.contains(classes.detail[0]) ? "Class Added" : "Class Dropped"), message: Text(classes.userClass.contains(classes.detail[0]) ? "Class is added!" : "Class is dropped!"), dismissButton: .default(Text("Got it!")))
                        })
                        
                        
                        if self.classes.detail[0].ClassLocation == [42.05780619999999,-87.67587739999999]{
                            Link(destination: URL(string: "https://www.mccormick.northwestern.edu/contact/tech-room-finder.html")!, label: {
                                VStack{
                                    Image(systemName: "location.circle.fill")
                                        .padding(.top)
                                        .padding(.horizontal, 16)
                                        .scaleEffect(1.5)
                                        .scaledToFill()
                                        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                    Text("Tech Room")
                                        .padding(.all)
                                        .font(.system(.caption2, design: .rounded))
                                }
                                .accentColor(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                                .frame(width: 100)
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
                        .frame(height: 100)
                        .foregroundColor(Color("SearchbarColor"))
                }
                .padding(.leading)
            }
        }
        
        
    }
}





