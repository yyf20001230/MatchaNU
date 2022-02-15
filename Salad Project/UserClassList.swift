//
//  ClassList.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/28/21.
//

import SwiftUI

struct UserClassList: View {
    @EnvironmentObject var classes: ClassLocations
    
    var body: some View {
        if classes.userClass.count != 0{
            ScrollView(showsIndicators: false){
                VStack{
                    ForEach(classes.userClass){ i in
                        Button(action: {
                            classes.detail.removeAll()
                            classes.detail.append(i)
                            classes.showUserClass = true
                        }){
                            VStack (alignment: .leading, spacing: 10){
                                HStack{
                                    Text(i.Major.components(separatedBy: " ")[0] + " " + i.Class.components(separatedBy: " ")[0] + "-" + i.Section.components(separatedBy: " ")[0].replacingOccurrences(of: ":", with: ""))
                                        .foregroundColor(Color("Default"))
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.bold)
                                        .tracking(-0.5)
                                        .padding(.leading)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    VStack(alignment: .leading, spacing: 4.0){
                                        Text(i.Instructor.dropLast())
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption, design: .rounded))
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                        Text(i.MeetingInfo.contains(": ") ? i.MeetingInfo.components(separatedBy: ": ")[0] : "TBA")
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption, design: .rounded))
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                        Text(i.MeetingInfo.contains(": ") ? i.MeetingInfo.components(separatedBy: ": ")[1] : "TBA")
                                            .foregroundColor(.secondary)
                                            .font(.system(.caption, design: .rounded))
                                            .tracking(-0.5)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                }
                                
                            }
                            .padding(.all)
                            
                        }
                        .background(Color("ClassColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                
                Rectangle()
                    .frame(height: 120)
                    .foregroundColor(Color("SearchbarColor"))
            }
            .padding(.all)
            
        }
    }
}

struct UserClassList_Previews: PreviewProvider {
    static var previews: some View {
        UserClassList()
    }
}
