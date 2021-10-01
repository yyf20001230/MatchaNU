//
//  EditView.swift
//  Salad Project
//
//  Created by Yunfan Yang on 9/30/21.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var classes: ClassLocations
    @State var Class = ""
    @State var Latitude = ""
    @State var Longitude = ""
    @State var ClassOverview = ""
    @State var Instructor = ""
    @State var MeetingInfo = ""
    @State var Major = ""
    @State var ClassLocation = ""
    @State var ClassName = ""
    @State var Section = ""
    
    @State private var showAlert = false
    
    var body: some View {

        
        Form{
            SwiftUI.Section (footer: Text("Enter class coordinate (this is important)").foregroundColor(.secondary)) {
                TextField("Enter coordinate latitude", text: $Latitude)
                TextField("Enter coordinate longitude", text: $Longitude)
                
            }
            .foregroundColor(.primary)
            
            SwiftUI.Section (footer: Text("Now, let's enter some class info (for fun!)").foregroundColor(.secondary)){
                TextField("Enter class number", text: $Class)
                TextField("Enter instructor name", text: $Instructor)
                TextField("Enter class meeting time", text: $MeetingInfo)
                TextField("Enter class overview", text: $ClassOverview)
                TextField("Enter class location", text: $ClassLocation)
                TextField("Enter class major", text: $Major)
                TextField("Enter class name", text: $ClassName)
                TextField("Enter class section", text: $Section)
                
            }
            .foregroundColor(.primary)
            
            
        }
        .frame(height: 500)
        
        Button(action: {
            let geolocation = [(self.Latitude as NSString).doubleValue, (self.Longitude as NSString).doubleValue]
            classes.userClass.append(ClassInfo(Class: self.Class + " " + self.ClassName, ClassLocation: geolocation, ClassOverview: self.ClassOverview, Instructor: self.Instructor + " ", Major: Major + " - your Major", MeetingInfo: self.ClassLocation + ": " + self.MeetingInfo, School: "", Section: self.Section + ": your section"))
            
            self.Class = ""
            self.Latitude = ""
            self.Longitude = ""
            self.ClassOverview = ""
            self.Instructor = ""
            self.MeetingInfo = ""
            self.Major = ""
            self.ClassLocation = ""
            self.ClassName = ""
            self.Section = ""
            
        }){
            Text("Submit")
                .frame(width: 250, height: 50, alignment: .center)
                .background(Color(#colorLiteral(red: 0.4745098039, green: 0.768627451, blue: 0.5843137255, alpha: 1)))
                .foregroundColor(Color.white)
                .cornerRadius(12)
        }
        
            

        
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
